const paidTimes = {
    currentData: [],

    async init() {
        console.log('🏇 Initializing Paid Times module...');
        this.setupEventListeners();
        await this.loadPaidTimes();
    },

    async loadPaidTimes() {
        try {
            ui.showLoading();
            console.log('📡 Loading paid times from API...');
            
            const data = await api.paidTimes.getAll();
            console.log('✅ Paid times loaded:', data);
            
            this.currentData = data || [];
            this.displayPaidTimes(this.currentData);
            
            ui.updateStats('paidtimes', this.currentData.length);
            
        } catch (error) {
            console.error('❌ Error loading paid times:', error);
            ui.showToast('error', 'שגיאה', 'לא הצלחנו לטעון את הפייד טיימס. נסה שוב.');
            this.currentData = [];
            this.displayPaidTimes([]);
        } finally {
            ui.hideLoading();
        }
    },

    displayPaidTimes(data) {
        const container = document.getElementById('paidtimes-grid');
        
        if (!container) {
            console.error('❌ Paid times grid container not found!');
            return;
        }

        if (!data || data.length === 0) {
            container.innerHTML = '<div class="empty-state">אין פייד טיימס להצגה</div>';
            ui.showEmptyState();
            return;
        }

        ui.hideEmptyState();
        container.innerHTML = data.map(pt => this.createPaidTimeCard(pt)).join('');
    },

    createPaidTimeCard(paidTime) {
        const slotTypeDisplay = paidTime.slotType === 'Short' ? 'קצר' : 'ארוך';
        const dateDisplay = paidTime.day ? new Date(paidTime.day).toLocaleDateString('he-IL') : 'לא צוין';
        
        return `
            <div class="card" data-id="${paidTime.paidTimeId}">
                <div class="card-header">
                    <h3>
                        <i class="fas fa-clock"></i>
                        ${paidTime.arenaName || 'זירה לא ידועה'}
                    </h3>
                    <span class="badge ${paidTime.slotType === 'Short' ? 'badge-warning' : 'badge-info'}">
                        ${slotTypeDisplay}
                    </span>
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <span class="label">
                            <i class="fas fa-trophy"></i>
                            תחרות:
                        </span>
                        <span class="value">#${paidTime.competitionId}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">
                            <i class="fas fa-user"></i>
                            רוכב:
                        </span>
                        <span class="value">#${paidTime.riderId}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">
                            <i class="fas fa-horse"></i>
                            סוס:
                        </span>
                        <span class="value">#${paidTime.horseId}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">
                            <i class="fas fa-user-tie"></i>
                            משלם:
                        </span>
                        <span class="value">#${paidTime.payerId}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">
                            <i class="fas fa-calendar"></i>
                            תאריך:
                        </span>
                        <span class="value">${dateDisplay}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">
                            <i class="fas fa-shekel-sign"></i>
                            מחיר:
                        </span>
                        <span class="value price">₪${paidTime.price ? paidTime.price.toFixed(2) : '0.00'}</span>
                    </div>
                </div>
                <div class="card-actions">
                    <button class="btn btn-edit" onclick="paidTimes.showEditForm(${paidTime.paidTimeId})">
                        <i class="fas fa-edit"></i>
                        עריכה
                    </button>
                    <button class="btn btn-delete" onclick="paidTimes.confirmDelete(${paidTime.paidTimeId})">
                        <i class="fas fa-trash"></i>
                        מחיקה
                    </button>
                </div>
            </div>
        `;
    },

    showAddForm() {
        const formHtml = `
            <form id="paidtime-form" class="modal-form">
                <div class="form-group">
                    <label for="pt-competitionId">
                        <i class="fas fa-trophy"></i>
                        מזהה תחרות
                        <span class="required">*</span>
                    </label>
                    <input 
                        type="number" 
                        id="pt-competitionId" 
                        name="competitionId" 
                        required 
                        min="1"
                        placeholder="הזן מזהה תחרות">
                </div>

                <div class="form-group">
                    <label for="pt-riderId">
                        <i class="fas fa-user"></i>
                        מזהה רוכב
                        <span class="required">*</span>
                    </label>
                    <input 
                        type="number" 
                        id="pt-riderId" 
                        name="riderId" 
                        required 
                        min="1"
                        placeholder="הזן מזהה רוכב">
                </div>

                <div class="form-group">
                    <label for="pt-horseId">
                        <i class="fas fa-horse"></i>
                        מזהה סוס
                        <span class="required">*</span>
                    </label>
                    <input 
                        type="number" 
                        id="pt-horseId" 
                        name="horseId" 
                        required 
                        min="1"
                        placeholder="הזן מזהה סוס">
                </div>

                <div class="form-group">
                    <label for="pt-payerId">
                        <i class="fas fa-user-tie"></i>
                        מזהה משלם
                        <span class="required">*</span>
                    </label>
                    <input 
                        type="number" 
                        id="pt-payerId" 
                        name="payerId" 
                        required 
                        min="1"
                        placeholder="הזן מזהה משלם">
                </div>

                <div class="form-group">
                    <label for="pt-arenaName">
                        <i class="fas fa-map-marker-alt"></i>
                        שם זירה
                        <span class="required">*</span>
                    </label>
                    <input 
                        type="text" 
                        id="pt-arenaName" 
                        name="arenaName" 
                        required
                        placeholder="הזן שם זירה (לדוגמה: זירה A)">
                </div>

                <div class="form-group">
                    <label for="pt-day">
                        <i class="fas fa-calendar"></i>
                        תאריך
                        <span class="required">*</span>
                    </label>
                    <input 
                        type="date" 
                        id="pt-day" 
                        name="day" 
                        required>
                </div>

                <div class="form-group">
                    <label for="pt-slotType">
                        <i class="fas fa-clock"></i>
                        סוג סלוט
                        <span class="required">*</span>
                    </label>
                    <select id="pt-slotType" name="slotType" required>
                        <option value="">בחר סוג סלוט</option>
                        <option value="Short">קצר (Short)</option>
                        <option value="Long">ארוך (Long)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="pt-price">
                        <i class="fas fa-shekel-sign"></i>
                        מחיר
                        <span class="required">*</span>
                    </label>
                    <input 
                        type="number" 
                        id="pt-price" 
                        name="price" 
                        required 
                        min="0" 
                        step="0.01"
                        placeholder="הזן מחיר">
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        שמור
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="ui.hideModal()">
                        <i class="fas fa-times"></i>
                        ביטול
                    </button>
                </div>
            </form>
        `;

        ui.showModal('הוספת פייד טיים חדש', formHtml);

        document.getElementById('paidtime-form').addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.savePaidTime();
        });
    },

    async savePaidTime() {
        const form = document.getElementById('paidtime-form');
        
        if (!ui.validateForm('paidtime-form')) {
            ui.showToast('warning', 'שים לב', 'אנא מלא את כל השדות הנדרשים');
            return;
        }

        const formData = new FormData(form);
        const paidTimeData = {
            competitionId: parseInt(formData.get('competitionId')),
            riderId: parseInt(formData.get('riderId')),
            horseId: parseInt(formData.get('horseId')),
            payerId: parseInt(formData.get('payerId')),
            arenaName: formData.get('arenaName').trim(),
            day: formData.get('day'),
            slotType: formData.get('slotType'),
            price: parseFloat(formData.get('price'))
        };

        try {
            ui.showLoading();
            console.log('💾 Saving paid time:', paidTimeData);
            
            await api.paidTimes.add(paidTimeData);
            
            ui.hideModal();
            ui.showToast('success', 'הצלחה!', 'הפייד טיים נוסף בהצלחה');
            
            // רענון הנתונים
            await this.loadPaidTimes();
            
        } catch (error) {
            console.error('❌ Error saving paid time:', error);
            ui.showToast('error', 'שגיאה', 'לא הצלחנו לשמור את הפייד טיים. נסה שוב.');
        } finally {
            ui.hideLoading();
        }
    },

    async showEditForm(paidTimeId) {
        try {
            ui.showLoading();
            
            const paidTime = this.currentData.find(pt => pt.paidTimeId === paidTimeId);
            
            if (!paidTime) {
                throw new Error('Paid time not found');
            }

            const formHtml = `
                <form id="paidtime-edit-form" class="modal-form">
                    <input type="hidden" id="edit-paidTimeId" value="${paidTime.paidTimeId}">
                    
                    <div class="form-group">
                        <label for="edit-competitionId">
                            <i class="fas fa-trophy"></i>
                            מזהה תחרות
                            <span class="required">*</span>
                        </label>
                        <input 
                            type="number" 
                            id="edit-competitionId" 
                            name="competitionId" 
                            value="${paidTime.competitionId}"
                            required 
                            min="1">
                    </div>

                    <div class="form-group">
                        <label for="edit-riderId">
                            <i class="fas fa-user"></i>
                            מזהה רוכב
                            <span class="required">*</span>
                        </label>
                        <input 
                            type="number" 
                            id="edit-riderId" 
                            name="riderId" 
                            value="${paidTime.riderId}"
                            required 
                            min="1">
                    </div>

                    <div class="form-group">
                        <label for="edit-horseId">
                            <i class="fas fa-horse"></i>
                            מזהה סוס
                            <span class="required">*</span>
                        </label>
                        <input 
                            type="number" 
                            id="edit-horseId" 
                            name="horseId" 
                            value="${paidTime.horseId}"
                            required 
                            min="1">
                    </div>

                    <div class="form-group">
                        <label for="edit-payerId">
                            <i class="fas fa-user-tie"></i>
                            מזהה משלם
                            <span class="required">*</span>
                        </label>
                        <input 
                            type="number" 
                            id="edit-payerId" 
                            name="payerId" 
                            value="${paidTime.payerId}"
                            required 
                            min="1">
                    </div>

                    <div class="form-group">
                        <label for="edit-arenaName">
                            <i class="fas fa-map-marker-alt"></i>
                            שם זירה
                            <span class="required">*</span>
                        </label>
                        <input 
                            type="text" 
                            id="edit-arenaName" 
                            name="arenaName" 
                            value="${paidTime.arenaName || ''}"
                            required>
                    </div>

                    <div class="form-group">
                        <label for="edit-day">
                            <i class="fas fa-calendar"></i>
                            תאריך
                            <span class="required">*</span>
                        </label>
                        <input 
                            type="date" 
                            id="edit-day" 
                            name="day" 
                            value="${paidTime.day ? paidTime.day.split('T')[0] : ''}"
                            required>
                    </div>

                    <div class="form-group">
                        <label for="edit-slotType">
                            <i class="fas fa-clock"></i>
                            סוג סלוט
                            <span class="required">*</span>
                        </label>
                        <select id="edit-slotType" name="slotType" required>
                            <option value="Short" ${paidTime.slotType === 'Short' ? 'selected' : ''}>קצר (Short)</option>
                            <option value="Long" ${paidTime.slotType === 'Long' ? 'selected' : ''}>ארוך (Long)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="edit-price">
                            <i class="fas fa-shekel-sign"></i>
                            מחיר
                            <span class="required">*</span>
                        </label>
                        <input 
                            type="number" 
                            id="edit-price" 
                            name="price" 
                            value="${paidTime.price || 0}"
                            required 
                            min="0" 
                            step="0.01">
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            עדכן
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="ui.hideModal()">
                            <i class="fas fa-times"></i>
                            ביטול
                        </button>
                    </div>
                </form>
            `;

            ui.showModal('עריכת פייד טיים', formHtml);

            document.getElementById('paidtime-edit-form').addEventListener('submit', async (e) => {
                e.preventDefault();
                await this.updatePaidTime();
            });

        } catch (error) {
            console.error('❌ Error showing edit form:', error);
            ui.showToast('error', 'שגיאה', 'לא הצלחנו לטעון את הפייד טיים לעריכה');
        } finally {
            ui.hideLoading();
        }
    },

    async updatePaidTime() {
        const form = document.getElementById('paidtime-edit-form');
        
        if (!ui.validateForm('paidtime-edit-form')) {
            ui.showToast('warning', 'שים לב', 'אנא מלא את כל השדות הנדרשים');
            return;
        }

        const formData = new FormData(form);
        const paidTimeData = {
            paidTimeId: parseInt(document.getElementById('edit-paidTimeId').value),
            competitionId: parseInt(formData.get('competitionId')),
            riderId: parseInt(formData.get('riderId')),
            horseId: parseInt(formData.get('horseId')),
            payerId: parseInt(formData.get('payerId')),
            arenaName: formData.get('arenaName').trim(),
            day: formData.get('day'),
            slotType: formData.get('slotType'),
            price: parseFloat(formData.get('price'))
        };

        try {
            ui.showLoading();
            console.log('💾 Updating paid time:', paidTimeData);
            
            await api.paidTimes.update(paidTimeData);
            
            ui.hideModal();
            ui.showToast('success', 'הצלחה!', 'הפייד טיים עודכן בהצלחה');
            
            await this.loadPaidTimes();
            
        } catch (error) {
            console.error('❌ Error updating paid time:', error);
            ui.showToast('error', 'שגיאה', 'לא הצלחנו לעדכן את הפייד טיים. נסה שוב.');
        } finally {
            ui.hideLoading();
        }
    },

    confirmDelete(paidTimeId) {
        const paidTime = this.currentData.find(pt => pt.paidTimeId === paidTimeId);
        
        if (!paidTime) {
            ui.showToast('error', 'שגיאה', 'הפייד טיים לא נמצא');
            return;
        }

        ui.confirm(
            'אישור מחיקה',
            `האם אתה בטוח שברצונך למחוק את הפייד טיים בזירה "${paidTime.arenaName}"?`,
            () => this.deletePaidTime(paidTimeId)
        );
    },

    async deletePaidTime(paidTimeId) {
        try {
            ui.showLoading();
            console.log('🗑️ Deleting paid time:', paidTimeId);
            
            await api.paidTimes.delete(paidTimeId);
            
            ui.showToast('success', 'הצלחה!', 'הפייד טיים נמחק בהצלחה');
            
            await this.loadPaidTimes();
            
        } catch (error) {
            console.error('❌ Error deleting paid time:', error);
            ui.showToast('error', 'שגיאה', 'לא הצלחנו למחוק את הפייד טיים. נסה שוב.');
        } finally {
            ui.hideLoading();
        }
    },

    searchPaidTimes(searchText) {
        const filtered = this.currentData.filter(pt => {
            const search = searchText.toLowerCase();
            return (
                (pt.arenaName && pt.arenaName.toLowerCase().includes(search)) ||
                (pt.slotType && pt.slotType.toLowerCase().includes(search)) ||
                pt.competitionId.toString().includes(search) ||
                pt.riderId.toString().includes(search) ||
                pt.horseId.toString().includes(search) ||
                pt.payerId.toString().includes(search)
            );
        });

        this.displayPaidTimes(filtered);
    },

    setupEventListeners() {
        
        const addBtn = document.getElementById('add-paidtime-btn');
        if (addBtn) {
            addBtn.addEventListener('click', () => this.showAddForm());
        }

        const searchInput = document.getElementById('paidtimes-search');
        if (searchInput) {
            let debounceTimer;
            searchInput.addEventListener('input', (e) => {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    this.searchPaidTimes(e.target.value);
                }, 300);
            });
        }

        console.log('✅ Paid Times event listeners set up');
    }
};

if (typeof module !== 'undefined' && module.exports) {
    module.exports = paidTimes;
}