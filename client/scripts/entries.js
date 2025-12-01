/* ================================================
   RideTrack - Entries Module
   ניהול הרשמות למקצים
   ================================================ */

const entries = {
    currentData: [],

    // ========================================
    // טעינה ראשונית
    // ========================================
    async init() {
        await this.loadEntries();
        this.setupEventListeners();
    },

    // ========================================
    // טעינת כל ההרשמות
    // ========================================
    async loadEntries() {
        try {
            UI.showLoading();
            const data = await API.entries.getAll();
            this.currentData = data;
            this.displayEntries(data);
            UI.updateStats('entries', data.length);
            UI.hideEmptyState('entriesEmptyState');
        } catch (error) {
            console.error('Error loading entries:', error);
            UI.showToast('error', 'שגיאה', 'לא ניתן לטעון הרשמות');
            UI.showEmptyState('entriesEmptyState');
        } finally {
            UI.hideLoading();
        }
    },

    // ========================================
    // הצגת הרשמות
    // ========================================
    displayEntries(data) {
        const grid = document.getElementById('entriesGrid');
        
        if (!data || data.length === 0) {
            grid.innerHTML = '';
            UI.showEmptyState('entriesEmptyState');
            return;
        }

        UI.hideEmptyState('entriesEmptyState');
        grid.innerHTML = data.map(entry => this.createEntryCard(entry)).join('');
    },

    // ========================================
    // יצירת כרטיס הרשמה
    // ========================================
    createEntryCard(entry) {
        return `
            <div class="data-card" data-entry-id="${entry.entryId}">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-user-circle"></i>
                        ${entry.riderName}
                    </h3>
                    <span class="card-badge badge-primary">#${entry.entryId}</span>
                </div>
                <div class="card-body">
                    <div class="card-info">
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-horse"></i>
                                סוס:
                            </span>
                            <span class="info-value">${entry.horseName}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-credit-card"></i>
                                משלם:
                            </span>
                            <span class="info-value">${entry.payerName}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-trophy"></i>
                                תחרות:
                            </span>
                            <span class="info-value">${entry.competitionName}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-list"></i>
                                מקצה:
                            </span>
                            <span class="info-value">${entry.className}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-calendar"></i>
                                תאריך:
                            </span>
                            <span class="info-value">${DateUtils.formatDate(entry.classDay)}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-dollar-sign"></i>
                                מחיר:
                            </span>
                            <span class="info-value">${NumberUtils.formatPrice(entry.classPrice)}</span>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <button class="btn btn-sm btn-primary" onclick="entries.showEditForm(${entry.entryId})">
                        <i class="fas fa-edit"></i>
                        ערוך
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="entries.confirmDelete(${entry.entryId})">
                        <i class="fas fa-trash"></i>
                        מחק
                    </button>
                </div>
            </div>
        `;
    },

    // ========================================
    // הצגת טופס הוספה
    // ========================================
    showAddForm() {
        const formContent = `
            <form id="entryForm" class="modal-form">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">מספר רוכב</label>
                        <input type="number" class="form-input" id="riderId" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label required">מספר סוס</label>
                        <input type="number" class="form-input" id="horseId" required min="1">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">מספר משלם</label>
                        <input type="number" class="form-input" id="payerId" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label required">מספר מקצה</label>
                        <input type="number" class="form-input" id="classId" required min="1">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-primary" onclick="entries.saveEntry()">
                        <i class="fas fa-save"></i>
                        שמור
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="UI.hideModal()">
                        <i class="fas fa-times"></i>
                        ביטול
                    </button>
                </div>
            </form>
        `;
        
        UI.showModal('הוספת הרשמה חדשה', formContent);
    },

    // ========================================
    // שמירת הרשמה
    // ========================================
    async saveEntry() {
        if (!UI.validateForm('entryForm')) {
            UI.showToast('warning', 'שים לב', 'נא למלא את כל השדות');
            return;
        }

        const entry = {
            riderId: parseInt(document.getElementById('riderId').value),
            horseId: parseInt(document.getElementById('horseId').value),
            payerId: parseInt(document.getElementById('payerId').value),
            classId: parseInt(document.getElementById('classId').value)
        };

        try {
            UI.showLoading();
            const result = await API.entries.add(entry);
            UI.hideModal();
            UI.showToast('success', 'הצלחה!', 'ההרשמה נוספה בהצלחה');
            await this.loadEntries();
        } catch (error) {
            console.error('Error adding entry:', error);
            UI.showToast('error', 'שגיאה', 'לא ניתן להוסיף הרשמה');
        } finally {
            UI.hideLoading();
        }
    },

    // ========================================
    // הצגת טופס עריכה
    // ========================================
    showEditForm(entryId) {
        const entry = this.currentData.find(e => e.entryId === entryId);
        if (!entry) return;

        const formContent = `
            <form id="entryEditForm" class="modal-form">
                <input type="hidden" id="editEntryId" value="${entry.entryId}">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">מספר רוכב</label>
                        <input type="number" class="form-input" id="editRiderId" value="${entry.riderId}" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label required">מספר סוס</label>
                        <input type="number" class="form-input" id="editHorseId" value="${entry.horseId}" required min="1">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label required">מספר משלם</label>
                        <input type="number" class="form-input" id="editPayerId" value="${entry.payerId}" required min="1">
                    </div>
                    <div class="form-group">
                        <label class="form-label required">מספר מקצה</label>
                        <input type="number" class="form-input" id="editClassId" value="${entry.classId}" required min="1">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-primary" onclick="entries.updateEntry()">
                        <i class="fas fa-save"></i>
                        עדכן
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="UI.hideModal()">
                        <i class="fas fa-times"></i>
                        ביטול
                    </button>
                </div>
            </form>
        `;
        
        UI.showModal('עריכת הרשמה', formContent);
    },

    // ========================================
    // עדכון הרשמה
    // ========================================
    async updateEntry() {
        if (!UI.validateForm('entryEditForm')) {
            UI.showToast('warning', 'שים לב', 'נא למלא את כל השדות');
            return;
        }

        const entry = {
            entryId: parseInt(document.getElementById('editEntryId').value),
            riderId: parseInt(document.getElementById('editRiderId').value),
            horseId: parseInt(document.getElementById('editHorseId').value),
            payerId: parseInt(document.getElementById('editPayerId').value),
            classId: parseInt(document.getElementById('editClassId').value)
        };

        try {
            UI.showLoading();
            await API.entries.update(entry);
            UI.hideModal();
            UI.showToast('success', 'הצלחה!', 'ההרשמה עודכנה בהצלחה');
            await this.loadEntries();
        } catch (error) {
            console.error('Error updating entry:', error);
            UI.showToast('error', 'שגיאה', 'לא ניתן לעדכן הרשמה');
        } finally {
            UI.hideLoading();
        }
    },

    // ========================================
    // אישור מחיקה
    // ========================================
    confirmDelete(entryId) {
        UI.confirm(
            'מחיקת הרשמה',
            'האם אתה בטוח שברצונך למחוק הרשמה זו?',
            () => this.deleteEntry(entryId)
        );
    },

    // ========================================
    // מחיקת הרשמה
    // ========================================
    async deleteEntry(entryId) {
        try {
            UI.showLoading();
            await API.entries.delete(entryId);
            UI.showToast('success', 'הצלחה!', 'ההרשמה נמחקה בהצלחה');
            await this.loadEntries();
        } catch (error) {
            console.error('Error deleting entry:', error);
            UI.showToast('error', 'שגיאה', 'לא ניתן למחוק הרשמה');
        } finally {
            UI.hideLoading();
        }
    },

    // ========================================
    // חיפוש
    // ========================================
    searchEntries(searchText) {
        if (!searchText || searchText.length < 2) {
            this.displayEntries(this.currentData);
            return;
        }

        const filtered = ArrayUtils.search(this.currentData, searchText, [
            'riderName',
            'horseName',
            'payerName',
            'competitionName',
            'className'
        ]);

        this.displayEntries(filtered);
    },

    // ========================================
    // Event Listeners
    // ========================================
    setupEventListeners() {
        // כפתור הוספה
        const addBtn = document.getElementById('addEntryBtn');
        if (addBtn) {
            addBtn.addEventListener('click', () => this.showAddForm());
        }

        // כפתור רענון
        const refreshBtn = document.getElementById('refreshEntries');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => this.loadEntries());
        }

        // חיפוש
        const searchInput = document.getElementById('searchEntries');
        if (searchInput) {
            searchInput.addEventListener('input', PerformanceUtils.debounce((e) => {
                this.searchEntries(e.target.value);
            }, 300));
        }

        // ניקוי חיפוש
        const clearBtn = document.getElementById('clearEntriesSearch');
        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                searchInput.value = '';
                this.searchEntries('');
            });
        }
    }
};