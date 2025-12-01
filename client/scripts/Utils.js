/* ================================================
   RideTrack - Utility Functions
   פונקציות עזר כלליות
   ================================================ */

// ========================================
// Date & Time Utilities
// ========================================
const DateUtils = {
    /**
     * פורמט תאריך לעברית
     */
    formatDate(dateString) {
        if (!dateString) return '-';
        const date = new Date(dateString);
        return new Intl.DateTimeFormat('he-IL', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
        }).format(date);
    },

    /**
     * פורמט תאריך ושעה
     */
    formatDateTime(dateString) {
        if (!dateString) return '-';
        const date = new Date(dateString);
        return new Intl.DateTimeFormat('he-IL', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        }).format(date);
    },

    /**
     * המרת תאריך לפורמט ISO
     */
    toISO(date) {
        return new Date(date).toISOString();
    },

    /**
     * בדיקה אם תאריך עבר
     */
    isPast(dateString) {
        return new Date(dateString) < new Date();
    },

    /**
     * בדיקה אם תאריך עתידי
     */
    isFuture(dateString) {
        return new Date(dateString) > new Date();
    }
};

// ========================================
// Number & Currency Utilities
// ========================================
const NumberUtils = {
    /**
     * פורמט מחיר בשקלים
     */
    formatPrice(price) {
        if (isNaN(price)) return '₪0.00';
        return `₪${parseFloat(price).toFixed(2)}`;
    },

    /**
     * פורמט מספר עם פסיקים
     */
    formatNumber(number) {
        if (isNaN(number)) return '0';
        return new Intl.NumberFormat('he-IL').format(number);
    },

    /**
     * המרה למספר בטוח
     */
    toNumber(value) {
        const num = parseFloat(value);
        return isNaN(num) ? 0 : num;
    }
};

// ========================================
// String Utilities
// ========================================
const StringUtils = {
    /**
     * חיתוך טקסט ארוך
     */
    truncate(text, maxLength = 50) {
        if (!text) return '';
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    },

    /**
     * ניקוי רווחים מיותרים
     */
    trim(text) {
        return text ? text.trim().replace(/\s+/g, ' ') : '';
    },

    /**
     * בדיקה אם מחרוזת ריקה
     */
    isEmpty(text) {
        return !text || text.trim().length === 0;
    },

    /**
     * המרה לאותיות גדולות בתחילת כל מילה
     */
    capitalize(text) {
        if (!text) return '';
        return text.split(' ')
            .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
            .join(' ');
    }
};

// ========================================
// Validation Utilities
// ========================================
const ValidationUtils = {
    /**
     * בדיקת שדה חובה
     */
    isRequired(value) {
        return value !== null && value !== undefined && value !== '';
    },

    /**
     * בדיקת מספר חיובי
     */
    isPositiveNumber(value) {
        const num = parseFloat(value);
        return !isNaN(num) && num > 0;
    },

    /**
     * בדיקת אימייל
     */
    isValidEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    },

    /**
     * בדיקת טלפון ישראלי
     */
    isValidPhone(phone) {
        const regex = /^0\d{1,2}-?\d{7}$/;
        return regex.test(phone);
    },

    /**
     * בדיקת תאריך
     */
    isValidDate(date) {
        return !isNaN(Date.parse(date));
    },

    /**
     * בדיקת טופס מלא
     */
    validateForm(formData, rules) {
        const errors = {};
        
        for (const [field, value] of Object.entries(formData)) {
            const fieldRules = rules[field];
            if (!fieldRules) continue;

            for (const rule of fieldRules) {
                if (!rule.validate(value)) {
                    errors[field] = rule.message;
                    break;
                }
            }
        }

        return {
            isValid: Object.keys(errors).length === 0,
            errors
        };
    }
};

// ========================================
// DOM Utilities
// ========================================
const DOMUtils = {
    /**
     * קבלת אלמנט
     */
    $(selector) {
        return document.querySelector(selector);
    },

    /**
     * קבלת כל האלמנטים
     */
    $$(selector) {
        return document.querySelectorAll(selector);
    },

    /**
     * הוספת class
     */
    addClass(element, className) {
        if (element) element.classList.add(className);
    },

    /**
     * הסרת class
     */
    removeClass(element, className) {
        if (element) element.classList.remove(className);
    },

    /**
     * בדיקה אם יש class
     */
    hasClass(element, className) {
        return element && element.classList.contains(className);
    },

    /**
     * החלפת class
     */
    toggleClass(element, className) {
        if (element) element.classList.toggle(className);
    },

    /**
     * הוספת אירוע
     */
    on(element, event, handler) {
        if (element) {
            element.addEventListener(event, handler);
        }
    },

    /**
     * הסרת אירוע
     */
    off(element, event, handler) {
        if (element) {
            element.removeEventListener(event, handler);
        }
    },

    /**
     * יצירת אלמנט
     */
    createElement(tag, classes = [], attributes = {}) {
        const element = document.createElement(tag);
        
        classes.forEach(cls => element.classList.add(cls));
        
        Object.entries(attributes).forEach(([key, value]) => {
            element.setAttribute(key, value);
        });
        
        return element;
    }
};

// ========================================
// Storage Utilities
// ========================================
const StorageUtils = {
    /**
     * שמירה ב-localStorage
     */
    save(key, value) {
        try {
            localStorage.setItem(key, JSON.stringify(value));
            return true;
        } catch (error) {
            console.error('Error saving to localStorage:', error);
            return false;
        }
    },

    /**
     * קריאה מ-localStorage
     */
    load(key, defaultValue = null) {
        try {
            const item = localStorage.getItem(key);
            return item ? JSON.parse(item) : defaultValue;
        } catch (error) {
            console.error('Error loading from localStorage:', error);
            return defaultValue;
        }
    },

    /**
     * מחיקה מ-localStorage
     */
    remove(key) {
        try {
            localStorage.removeItem(key);
            return true;
        } catch (error) {
            console.error('Error removing from localStorage:', error);
            return false;
        }
    },

    /**
     * ניקוי כל ה-localStorage
     */
    clear() {
        try {
            localStorage.clear();
            return true;
        } catch (error) {
            console.error('Error clearing localStorage:', error);
            return false;
        }
    }
};

// ========================================
// Debounce & Throttle
// ========================================
const PerformanceUtils = {
    /**
     * Debounce - עיכוב ביצוע פונקציה
     */
    debounce(func, wait = 300) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    /**
     * Throttle - הגבלת קריאות לפונקציה
     */
    throttle(func, limit = 300) {
        let inThrottle;
        return function executedFunction(...args) {
            if (!inThrottle) {
                func(...args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }
};

// ========================================
// Array Utilities
// ========================================
const ArrayUtils = {
    /**
     * סינון רשימה לפי טקסט חיפוש
     */
    search(array, searchText, fields) {
        if (!searchText) return array;
        
        const lowerSearch = searchText.toLowerCase();
        
        return array.filter(item => {
            return fields.some(field => {
                const value = item[field];
                return value && value.toString().toLowerCase().includes(lowerSearch);
            });
        });
    },

    /**
     * מיון רשימה
     */
    sort(array, field, ascending = true) {
        return [...array].sort((a, b) => {
            const aVal = a[field];
            const bVal = b[field];
            
            if (aVal < bVal) return ascending ? -1 : 1;
            if (aVal > bVal) return ascending ? 1 : -1;
            return 0;
        });
    },

    /**
     * קבוצות ייחודיות
     */
    unique(array, field) {
        const seen = new Set();
        return array.filter(item => {
            const value = item[field];
            if (seen.has(value)) {
                return false;
            }
            seen.add(value);
            return true;
        });
    }
};

// ========================================
// Export Utilities
// ========================================
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        DateUtils,
        NumberUtils,
        StringUtils,
        ValidationUtils,
        DOMUtils,
        StorageUtils,
        PerformanceUtils,
        ArrayUtils
    };
}