const UI = {
    showModal(title, content) {
        const modal = document.getElementById('mainModal');
        const modalBody = document.getElementById('modalBody');
        
        modalBody.innerHTML = `
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-clipboard-list"></i>
                    ${title}
                </h3>
            </div>
            ${content}
        `;
        
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    },

    hideModal() {
        const modal = document.getElementById('mainModal');
        modal.classList.remove('show');
        document.body.style.overflow = '';
    },

    showToast(type, title, message) {
        const container = document.getElementById('toastContainer');
        const id = `toast-${Date.now()}`;
        
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-exclamation-circle',
            warning: 'fa-exclamation-triangle',
            info: 'fa-info-circle'
        };
        
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.id = id;
        toast.innerHTML = `
            <i class="fas ${icons[type]} toast-icon"></i>
            <div class="toast-content">
                <div class="toast-title">${title}</div>
                <div class="toast-message">${message}</div>
            </div>
            <button class="toast-close" onclick="UI.removeToast('${id}')">
                <i class="fas fa-times"></i>
            </button>
            <div class="toast-progress"></div>
        `;
        
        container.appendChild(toast);
        
        setTimeout(() => {
            UI.removeToast(id);
        }, 5000);
    },

    removeToast(id) {
        const toast = document.getElementById(id);
        if (toast) {
            toast.classList.add('removing');
            setTimeout(() => {
                toast.remove();
            }, 300);
        }
    },

    showLoading() {
        const overlay = document.getElementById('loadingOverlay');
        overlay.classList.add('show');
    },

    hideLoading() {
        const overlay = document.getElementById('loadingOverlay');
        overlay.classList.remove('show');
    },

    updateStats(type, count) {
        const element = document.getElementById(`total${type.charAt(0).toUpperCase() + type.slice(1)}`);
        if (element) {
            this.animateNumber(element, parseInt(element.textContent) || 0, count);
        }
    },

    animateNumber(element, start, end) {
        const duration = 1000;
        const range = end - start;
        const increment = end > start ? 1 : -1;
        const stepTime = Math.abs(Math.floor(duration / range));
        
        let current = start;
        const timer = setInterval(() => {
            current += increment;
            element.textContent = current;
            if (current === end) {
                clearInterval(timer);
            }
        }, stepTime);
    },

    showEmptyState(containerId) {
        const container = document.getElementById(containerId);
        if (container) {
            container.style.display = 'flex';
        }
    },

    hideEmptyState(containerId) {
        const container = document.getElementById(containerId);
        if (container) {
            container.style.display = 'none';
        }
    },

    confirm(title, message, onConfirm) {
        const content = `
            <div class="confirmation-dialog">
                <p class="confirmation-message">${message}</p>
                <div class="form-actions">
                    <button class="btn btn-danger" onclick="UI.handleConfirm(true)">
                        <i class="fas fa-check"></i>
                        אישור
                    </button>
                    <button class="btn btn-secondary" onclick="UI.handleConfirm(false)">
                        <i class="fas fa-times"></i>
                        ביטול
                    </button>
                </div>
            </div>
        `;
        
        this.confirmCallback = onConfirm;
        this.showModal(title, content);
    },

    handleConfirm(confirmed) {
        if (confirmed && this.confirmCallback) {
            this.confirmCallback();
        }
        this.hideModal();
        this.confirmCallback = null;
    },

    validateForm(formId) {
        const form = document.getElementById(formId);
        if (!form) return false;
        
        let isValid = true;
        const inputs = form.querySelectorAll('.form-input, .form-select, .form-textarea');
        
        inputs.forEach(input => {
            
            input.classList.remove('error');
            const errorElement = input.nextElementSibling;
            if (errorElement && errorElement.classList.contains('form-error')) {
                errorElement.remove();
            }
            
            if (input.hasAttribute('required') && !input.value.trim()) {
                isValid = false;
                input.classList.add('error');
                
                const error = document.createElement('span');
                error.className = 'form-error';
                error.textContent = 'שדה חובה';
                input.parentNode.insertBefore(error, input.nextSibling);
            }
            
            if (input.type === 'number' && input.value) {
                const num = parseFloat(input.value);
                if (isNaN(num) || num < 1) {
                    isValid = false;
                    input.classList.add('error');
                    
                    const error = document.createElement('span');
                    error.className = 'form-error';
                    error.textContent = 'חייב להיות מספר חיובי';
                    input.parentNode.insertBefore(error, input.nextSibling);
                }
            }
        });
        
        return isValid;
    },

    clearForm(formId) {
        const form = document.getElementById(formId);
        if (form) {
            form.reset();
            
            const inputs = form.querySelectorAll('.form-input, .form-select, .form-textarea');
            inputs.forEach(input => {
                input.classList.remove('error');
            });
            
            const errors = form.querySelectorAll('.form-error');
            errors.forEach(error => error.remove());
        }
    }
};