const shavingsOrders = {
    currentData: [],

    async init() {
        await this.loadShavingsOrders();
        this.setupEventListeners();
    },

    async loadShavingsOrders() {
        try {
            UI.showLoading();
            const data = await API.shavingsOrders.getAll();
            this.currentData = data;
            this.displayShavingsOrders(data);
            UI.updateStats('shavings', data.length);
            UI.hideEmptyState('shavingsEmptyState');
        } catch (error) {
            console.error('Error loading shavings orders:', error);
            UI.showToast('error', 'שגיאה', 'לא ניתן לטעון הזמנות נסורת');
            UI.showEmptyState('shavingsEmptyState');
        } finally {
            UI.hideLoading();
        }
    },

    displayShavingsOrders(data) {
        const grid = document.getElementById('shavingsGrid');
        
        if (!data || data.length === 0) {
            grid.innerHTML = '';
            UI.showEmptyState('shavingsEmptyState');
            return;
        }

        UI.hideEmptyState('shavingsEmptyState');
        grid.innerHTML = data.map(order => this.createOrderCard(order)).join('');
    },

    createOrderCard(order) {
        return `
            <div class="data-card" data-order-id="${order.shavingsOrderId}">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-box"></i>
                        הזמנה #${order.shavingsOrderId}
                    </h3>
                    <span class="card-badge badge-info">${order.bagsQuantity} שקים</span>
                </div>
                <div class="card-body">
                    <div class="card-info">
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-warehouse"></i> תא:</span>
                            <span class="info-value">#${order.stallId}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-calendar"></i> תאריך הזמנה:</span>
                            <span class="info-value">${DateUtils.formatDateTime(order.orderDate)}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-box"></i> כמות:</span>
                            <span class="info-value">${order.bagsQuantity} שקים</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-tag"></i> מחיר לשק:</span>
                            <span class="info-value">${NumberUtils.formatPrice(order.pricePerBag)}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-dollar-sign"></i> סה"כ:</span>
                            <span class="info-value">${NumberUtils.formatPrice(order.totalPrice)}</span>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <button class="btn btn-sm btn-primary" onclick="shavingsOrders.showEditForm(${order.shavingsOrderId})">
                        <i class="fas fa-edit"></i> ערוך
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="shavingsOrders.confirmDelete(${order.shavingsOrderId})">
                        <i class="fas fa-trash"></i> מחק
                    </button>
                </div>
            </div>
        `;
    },

    showAddForm() {
        const formContent = `
            <form id="shavingsForm" class="modal-form">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">מספר תא</label>
                        <input type="number" class="form-input" id="stallId" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label required">תאריך הזמנה</label>
                        <input type="datetime-local" class="form-input" id="orderDate" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">כמות שקים</label>
                        <input type="number" class="form-input" id="bagsQuantity" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label required">מחיר לשק</label>
                        <input type="number" class="form-input" id="pricePerBag" required min="0" step="0.01">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label required">מחיר כולל</label>
                    <input type="number" class="form-input" id="totalPrice" required min="0" step="0.01">
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-primary" onclick="shavingsOrders.saveOrder()">
                        <i class="fas fa-save"></i> שמור
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="UI.hideModal()">
                        <i class="fas fa-times"></i> ביטול
                    </button>
                </div>
            </form>
        `;
        UI.showModal('הוספת הזמנת נסורת', formContent);
    },

    async saveOrder() {
        if (!UI.validateForm('shavingsForm')) {
            UI.showToast('warning', 'שים לב', 'נא למלא את כל השדות');
            return;
        }

        const order = {
            stallId: parseInt(document.getElementById('stallId').value),
            orderDate: document.getElementById('orderDate').value,
            bagsQuantity: parseInt(document.getElementById('bagsQuantity').value),
            pricePerBag: parseFloat(document.getElementById('pricePerBag').value),
            totalPrice: parseFloat(document.getElementById('totalPrice').value)
        };

        try {
            UI.showLoading();
            await API.shavingsOrders.add(order);
            UI.hideModal();
            UI.showToast('success', 'הצלחה!', 'ההזמנה נוספה בהצלחה');
            await this.loadShavingsOrders();
        } catch (error) {
            console.error('Error adding order:', error);
            UI.showToast('error', 'שגיאה', 'לא ניתן להוסיף הזמנה');
        } finally {
            UI.hideLoading();
        }
    },

    showEditForm(orderId) {
        const order = this.currentData.find(o => o.shavingsOrderId === orderId);
        if (!order) return;

        const formContent = `
            <form id="shavingsEditForm" class="modal-form">
                <input type="hidden" id="editOrderId" value="${order.shavingsOrderId}">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">מספר תא</label>
                        <input type="number" class="form-input" id="editStallId" value="${order.stallId}" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label required">תאריך הזמנה</label>
                        <input type="datetime-local" class="form-input" id="editOrderDate" value="${DateUtils.toISO(order.orderDate)}" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">כמות שקים</label>
                        <input type="number" class="form-input" id="editBagsQuantity" value="${order.bagsQuantity}" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label required">מחיר לשק</label>
                        <input type="number" class="form-input" id="editPricePerBag" value="${order.pricePerBag}" required min="0" step="0.01">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label required">מחיר כולל</label>
                    <input type="number" class="form-input" id="editTotalPrice" value="${order.totalPrice}" required min="0" step="0.01">
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-primary" onclick="shavingsOrders.updateOrder()">
                        <i class="fas fa-save"></i> עדכן
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="UI.hideModal()">
                        <i class="fas fa-times"></i> ביטול
                    </button>
                </div>
            </form>
        `;
        UI.showModal('עריכת הזמנת נסורת', formContent);
    },

    async updateOrder() {
        if (!UI.validateForm('shavingsEditForm')) {
            UI.showToast('warning', 'שים לב', 'נא למלא את כל השדות');
            return;
        }

        const order = {
            shavingsOrderId: parseInt(document.getElementById('editOrderId').value),
            stallId: parseInt(document.getElementById('editStallId').value),
            orderDate: document.getElementById('editOrderDate').value,
            bagsQuantity: parseInt(document.getElementById('editBagsQuantity').value),
            pricePerBag: parseFloat(document.getElementById('editPricePerBag').value),
            totalPrice: parseFloat(document.getElementById('editTotalPrice').value)
        };

        try {
            UI.showLoading();
            await API.shavingsOrders.update(order);
            UI.hideModal();
            UI.showToast('success', 'הצלחה!', 'ההזמנה עודכנה בהצלחה');
            await this.loadShavingsOrders();
        } catch (error) {
            console.error('Error updating order:', error);
            UI.showToast('error', 'שגיאה', 'לא ניתן לעדכן הזמנה');
        } finally {
            UI.hideLoading();
        }
    },

    confirmDelete(orderId) {
        UI.confirm(
            'מחיקת הזמנה',
            'האם אתה בטוח שברצונך למחוק הזמנה זו?',
            () => this.deleteOrder(orderId)
        );
    },

    async deleteOrder(orderId) {
        try {
            UI.showLoading();
            await API.shavingsOrders.delete(orderId);
            UI.showToast('success', 'הצלחה!', 'ההזמנה נמחקה בהצלחה');
            await this.loadShavingsOrders();
        } catch (error) {
            console.error('Error deleting order:', error);
            UI.showToast('error', 'שגיאה', 'לא ניתן למחוק הזמנה');
        } finally {
            UI.hideLoading();
        }
    },

    searchOrders(searchText) {
        if (!searchText || searchText.length < 2) {
            this.displayShavingsOrders(this.currentData);
            return;
        }

        const filtered = ArrayUtils.search(this.currentData, searchText, [
            'stallId',
            'bagsQuantity'
        ]);

        this.displayShavingsOrders(filtered);
    },

    setupEventListeners() {
        const addBtn = document.getElementById('addShavingsBtn');
        if (addBtn) {
            addBtn.addEventListener('click', () => this.showAddForm());
        }

        const refreshBtn = document.getElementById('refreshShavings');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => this.loadShavingsOrders());
        }

        const searchInput = document.getElementById('searchShavings');
        if (searchInput) {
            searchInput.addEventListener('input', PerformanceUtils.debounce((e) => {
                this.searchOrders(e.target.value);
            }, 300));
        }

        const clearBtn = document.getElementById('clearShavingsSearch');
        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                searchInput.value = '';
                this.searchOrders('');
            });
        }
    }
};