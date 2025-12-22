/**
 * Gestion du panier côté client
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialiser le compteur du panier au chargement
    loadCartCount();
});

/**
 * Charger le nombre d'articles du panier
 */
function loadCartCount() {
    fetch('/src/api/get-cart-count.php')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const badge = document.getElementById('cart-count');
                if (badge) {
                    badge.textContent = data.count;
                }
            }
        })
        .catch(error => console.error('Erreur chargement panier:', error));
}

/**
 * Ajouter au panier (formulaire)
 */
function addToCart(bookId, quantity = 1) {
    const formData = new FormData();
    formData.append('book_id', bookId);
    formData.append('quantity', quantity);
    
    fetch('/src/api/add-to-cart.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            loadCartCount();
            showNotification('success', data.message);
        } else {
            showNotification('error', data.message);
        }
    })
    .catch(error => {
        console.error('Erreur:', error);
        showNotification('error', 'Erreur lors de l\'ajout au panier');
    });
}

/**
 * Afficher une notification
 */
function showNotification(type, message) {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        border-radius: 4px;
        background-color: ${type === 'success' ? '#28a745' : '#dc3545'};
        color: white;
        z-index: 1000;
        animation: slideIn 0.3s ease-in-out;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-in-out';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}
