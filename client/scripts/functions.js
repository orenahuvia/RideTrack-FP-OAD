/* ================================================
   RideTrack - General Functions
   פונקציות כלליות
   ================================================ */

// ========================================
// פונקציות נוספות שלא נכללו במקומות אחרים
// ========================================

// טיפול בשגיאות גלובלי
window.addEventListener('error', (event) => {
    console.error('Global error:', event.error);
    // אפשר להוסיף כאן שליחת שגיאות לשרת
});

// טיפול ב-unhandled promise rejection
window.addEventListener('unhandledrejection', (event) => {
    console.error('Unhandled promise rejection:', event.reason);
});

// ========================================
// Helper Functions
// ========================================

/**
 * בדיקה אם השרת זמין
 */
async function checkServerConnection() {
    try {
        const response = await fetch(`${API_CONFIG.baseURL}/Entries`, {
            method: 'HEAD'
        });
        return response.ok;
    } catch (error) {
        return false;
    }
}

/**
 * בדיקת חיבור אינטרנט
 */
function checkInternetConnection() {
    return navigator.onLine;
}

/**
 * הצגת הודעת חיבור
 */
window.addEventListener('online', () => {
    UI.showToast('success', 'חיבור', 'החיבור לאינטרנט חזר');
});

window.addEventListener('offline', () => {
    UI.showToast('warning', 'התנתקות', 'אין חיבור לאינטרנט');
});

/**
 * Export לExcel (עתידי)
 */
function exportToExcel(data, filename) {
    console.log('Export to Excel:', filename, data);
    UI.showToast('info', 'בקרוב', 'תכונת ייצוא לExcel בפיתוח');
}

/**
 * Print (עתידי)
 */
function printData(elementId) {
    window.print();
}

/**
 * Scroll to top
 */
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

// הוספת כפתור scroll to top
window.addEventListener('scroll', () => {
    const scrollBtn = document.getElementById('scrollTopBtn');
    if (scrollBtn) {
        if (window.scrollY > 300) {
            scrollBtn.style.display = 'block';
        } else {
            scrollBtn.style.display = 'none';
        }
    }
});