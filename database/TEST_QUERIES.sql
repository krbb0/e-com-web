-- ============================================
-- SCRIPTS DE TEST ET VÉRIFICATION
-- À exécuter dans la console MySQL
-- ============================================

USE ecom_bookstore;

-- ============================================
-- VÉRIFICATIONS BASIQUES
-- ============================================

-- Vérifier les tables existent
SHOW TABLES;
-- Résultat attendu: 6 tables (users, categories, books, cart, orders, order_items)

-- Vérifier la structure des tables
DESCRIBE users;
DESCRIBE categories;
DESCRIBE books;
DESCRIBE cart;

-- ============================================
-- VÉRIFICATION DES DONNÉES
-- ============================================

-- Nombre d'utilisateurs
SELECT COUNT(*) as total_users FROM users;
-- Résultat attendu: >= 2 (admin + jean.dupont)

-- Lister tous les utilisateurs
SELECT id, username, email, role FROM users;

-- Nombre de catégories
SELECT COUNT(*) as total_categories FROM categories;
-- Résultat attendu: 6

-- Lister les catégories
SELECT id, name, description FROM categories;

-- Nombre de livres
SELECT COUNT(*) as total_books FROM books;
-- Résultat attendu: 10

-- Lister les livres avec détails
SELECT b.id, b.title, b.author, b.price, b.stock, c.name as category
FROM books b
LEFT JOIN categories c ON b.category_id = c.id
ORDER BY b.title;

-- ============================================
-- VÉRIFICATION DES CLÉS ÉTRANGÈRES
-- ============================================

-- Vérifier que les livres pointent vers des catégories valides
SELECT b.id, b.title, b.category_id, c.name
FROM books b
LEFT JOIN categories c ON b.category_id = c.id
WHERE b.category_id IS NOT NULL AND c.id IS NULL;
-- Résultat attendu: (vide = OK)

-- ============================================
-- TEST: INSCRIPTION D'UN UTILISATEUR
-- ============================================

-- Insérer un nouvel utilisateur de test
INSERT INTO users (username, email, password_hash, role)
VALUES ('test.user', 'test@test.com', '$2y$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36B6F7eq', 'user');

-- Vérifier l'insertion
SELECT * FROM users WHERE username = 'test.user';

-- Nettoyer (optionnel)
DELETE FROM users WHERE username = 'test.user';

-- ============================================
-- TEST: PANIER D'UN UTILISATEUR
-- ============================================

-- Récupérer l'ID de jean.dupont
SET @user_id = (SELECT id FROM users WHERE username = 'jean.dupont');

-- Ajouter un article au panier
INSERT INTO cart (user_id, book_id, quantity)
VALUES (@user_id, 1, 2);  -- 2 copies du livre 1

-- Vérifier le panier
SELECT c.id, c.user_id, c.book_id, b.title, b.price, c.quantity, 
       (b.price * c.quantity) as subtotal
FROM cart c
JOIN books b ON c.book_id = b.id
WHERE c.user_id = @user_id;

-- Total du panier
SELECT SUM(b.price * c.quantity) as total
FROM cart c
JOIN books b ON c.book_id = b.id
WHERE c.user_id = @user_id;

-- Nombre d'articles
SELECT COUNT(*) as item_count FROM cart WHERE user_id = @user_id;

-- Vider le panier de test
DELETE FROM cart WHERE user_id = @user_id;

-- ============================================
-- TEST: RECHERCHE ET FILTRAGE
-- ============================================

-- Rechercher par titre
SELECT id, title, author, price FROM books
WHERE title LIKE '%Harry%';

-- Rechercher par auteur
SELECT id, title, author, price FROM books
WHERE author LIKE '%Tolkien%';

-- Filtrer par catégorie (Science-Fiction = id 1)
SELECT b.id, b.title, b.author, b.price, c.name
FROM books b
JOIN categories c ON b.category_id = c.id
WHERE b.category_id = 1;

-- Filtrer par prix (entre 15€ et 25€)
SELECT id, title, price FROM books
WHERE price >= 15 AND price <= 25
ORDER BY price;

-- Combiné: Science-Fiction entre 15€ et 30€
SELECT b.id, b.title, b.author, b.price, c.name
FROM books b
JOIN categories c ON b.category_id = c.id
WHERE b.category_id = 1 AND b.price BETWEEN 15 AND 30;

-- ============================================
-- TEST: INTÉGRITÉ DES DONNÉES
-- ============================================

-- Vérifier qu'aucun livre n'a de catégorie invalide
SELECT COUNT(*) as orphan_books
FROM books
WHERE category_id NOT IN (SELECT id FROM categories);
-- Résultat attendu: 0

-- Vérifier qu'aucun panier n'a de livre invalide
SELECT COUNT(*) as invalid_cart_items
FROM cart
WHERE book_id NOT IN (SELECT id FROM books);
-- Résultat attendu: 0

-- Vérifier qu'aucun panier n'a d'utilisateur invalide
SELECT COUNT(*) as invalid_cart_users
FROM cart
WHERE user_id NOT IN (SELECT id FROM users);
-- Résultat attendu: 0

-- ============================================
-- TEST: STATISTIQUES
-- ============================================

-- Nombre de livres par catégorie
SELECT c.name, COUNT(b.id) as book_count
FROM categories c
LEFT JOIN books b ON c.id = b.category_id
GROUP BY c.id, c.name
ORDER BY book_count DESC;

-- Prix moyen des livres
SELECT 
    ROUND(AVG(price), 2) as average_price,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM books;

-- Stock total
SELECT SUM(stock) as total_stock FROM books;

-- Livres en rupture de stock
SELECT id, title, stock FROM books WHERE stock = 0;

-- Livres avec stock faible (< 10)
SELECT id, title, stock FROM books WHERE stock < 10 AND stock > 0;

-- ============================================
-- OPÉRATIONS ADMINISTRATEUR
-- ============================================

-- Promouvoir un utilisateur en admin
UPDATE users SET role = 'admin' WHERE id = 2;  -- Remplacer 2 par l'ID réel

-- Rétrogader un admin en user
UPDATE users SET role = 'user' WHERE id = 3;

-- Vérifier les changements
SELECT id, username, role FROM users;

-- ============================================
-- MAINTENANCE
-- ============================================

-- Supprimer tous les paniers d'un utilisateur
DELETE FROM cart WHERE user_id = 2;

-- Supprimer tous les paniers (une fois les commandes passées)
TRUNCATE TABLE cart;

-- Vérifier l'utilisation de l'espace
SHOW TABLE STATUS FROM ecom_bookstore;

-- Optimiser les tables
OPTIMIZE TABLE users;
OPTIMIZE TABLE books;
OPTIMIZE TABLE cart;

-- ============================================
-- SÉCURITÉ - VÉRIFICATIONS
-- ============================================

-- Vérifier que les mots de passe sont hashés (non en clair)
SELECT username, password_hash 
FROM users 
LIMIT 3;
-- Résultat attendu: Hash commençant par $2y$ (bcrypt)

-- Vérifier qu'aucun mot de passe n'est stocké en clair
SELECT COUNT(*) as clear_passwords
FROM users
WHERE password_hash NOT LIKE '$2%';
-- Résultat attendu: 0

-- ============================================
-- REQUÊTES UTILES POUR LE DÉVELOPPEMENT
-- ============================================

-- Récupérer tous les livres d'une catégorie avec pagination
SELECT b.id, b.title, b.author, b.price, c.name
FROM books b
LEFT JOIN categories c ON b.category_id = c.id
LIMIT 12 OFFSET 0;  -- 12 livres par page, page 1

-- Détail complet d'un livre
SELECT * FROM books WHERE id = 1;

-- Détail d'une commande
SELECT o.id, o.user_id, u.username, o.total_price, o.status, o.created_at,
       oi.id as item_id, oi.book_id, b.title, oi.quantity, oi.price_at_purchase
FROM orders o
JOIN users u ON o.user_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN books b ON oi.book_id = b.id
WHERE o.id = 1;

-- ============================================
-- SAUVEGARDE ET RESTAURATION
-- ============================================

-- Exporter les données (via ligne de commande):
-- mysqldump -u root -p ecom_bookstore > backup.sql

-- Importer les données (via ligne de commande):
-- mysql -u root -p ecom_bookstore < backup.sql

-- Exporter une table
-- mysqldump -u root -p ecom_bookstore books > books.sql

-- ============================================
-- NOTES UTILES
-- ============================================

/*
1. Pour générer le hash d'un mot de passe en PHP:
   $hash = password_hash('mypassword', PASSWORD_DEFAULT);
   
2. Hash de "admin123" (fourni):
   $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi

3. Pour mettre à jour le mot de passe d'un admin:
   UPDATE users SET password_hash = '$2y$10$...' WHERE username = 'admin';

4. Reset complet (attention!):
   DELETE FROM cart;
   DELETE FROM orders;
   DELETE FROM order_items;
   DELETE FROM books;
   DELETE FROM users;
   DELETE FROM categories;
   -- Puis re-importer schema.sql
*/
