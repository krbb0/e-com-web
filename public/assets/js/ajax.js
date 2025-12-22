/**
 * Fonctions AJAX réutilisables
 */

/**
 * Fonction de debounce pour éviter trop de requêtes
 */
function debounce(func, delay) {
    let timeoutId;
    return function(...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func(...args), delay);
    };
}

/**
 * Appliquer les filtres et chercher les livres
 */
function applyFilters() {
    const keyword = document.getElementById('search-input')?.value || '';
    const categoryId = document.getElementById('category-filter')?.value || '';
    const minPrice = document.getElementById('price-min')?.value || '';
    const maxPrice = document.getElementById('price-max')?.value || '';
    
    const params = new URLSearchParams();
    if (keyword) params.append('keyword', keyword);
    if (categoryId) params.append('category_id', categoryId);
    if (minPrice) params.append('min_price', minPrice);
    if (maxPrice) params.append('max_price', maxPrice);
    
    fetch(`/src/api/search.php?${params.toString()}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                displayBooks(data.results);
            }
        })
        .catch(error => console.error('Erreur:', error));
}

/**
 * Réinitialiser les filtres
 */
function resetFilters() {
    document.getElementById('search-input').value = '';
    document.getElementById('category-filter').value = '';
    document.getElementById('price-min').value = '';
    document.getElementById('price-max').value = '';
    
    location.reload();
}

/**
 * Afficher les livres dans la grille
 */
function displayBooks(books) {
    const container = document.getElementById('books-container');
    
    if (books.length === 0) {
        container.innerHTML = '<p class="no-results">Aucun livre trouvé</p>';
        return;
    }
    
    let html = '';
    books.forEach(book => {
        html += `
            <div class="book-card">
                <div class="book-image">
                    <img src="${book.cover_image || '/assets/images/no-cover.jpg'}" 
                         alt="${book.title}">
                </div>
                <div class="book-info">
                    <h3>${book.title}</h3>
                    <p class="author">par ${book.author}</p>
                    <p class="category">
                        <small>${book.category_name || 'N/A'}</small>
                    </p>
                    <div class="book-price">${parseFloat(book.price).toFixed(2)} €</div>
                    <a href="/pages/book-detail.php?id=${book.id}" class="btn btn-info">
                        Voir détails
                    </a>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

/**
 * Mettre à jour le nombre d'articles dans le panier (badge)
 */
function updateCartCount() {
    if (typeof sessionStorage === 'undefined') {
        // Fallback si pas de sessionStorage
        const badge = document.getElementById('cart-count');
        if (badge && badge.textContent) {
            badge.textContent = parseInt(badge.textContent) + 1;
        }
        return;
    }
    
    let count = parseInt(sessionStorage.getItem('cartCount') || '0');
    count++;
    sessionStorage.setItem('cartCount', count);
    
    const badge = document.getElementById('cart-count');
    if (badge) {
        badge.textContent = count;
    }
}
