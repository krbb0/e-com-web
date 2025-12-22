# 🏗️ Architecture backend - Explication détaillée

Vue d'ensemble du fonctionnement backend du projet LibreBooks.

## 📊 Diagramme architectural

```
┌─────────────────────────────────────────┐
│      REQUÊTE UTILISATEUR (Frontend)     │
│      GET/POST http://localhost:8000     │
└────────────────────┬────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
   ┌─────────┐              ┌─────────┐
   │  Pages  │              │   API   │
   │  (.php) │              │ (.php)  │
   └────┬────┘              └────┬────┘
        │ Inclut                │ Retourne
        │                       │ JSON
        ▼                       ▼
   ┌──────────────────────────────────────┐
   │      Classe métier (src/classes/)    │
   │  ┌────────────┐  ┌────────────────┐  │
   │  │   Auth     │  │     User       │  │
   │  └────────────┘  └────────────────┘  │
   │  ┌────────────┐  ┌────────────────┐  │
   │  │   Book     │  │     Cart       │  │
   │  └────────────┘  └────────────────┘  │
   └────────┬─────────────────────────────┘
            │ Exécute requêtes
            ▼
   ┌──────────────────────────┐
   │  Database (src/config/)  │
   │      PDO + MySQL         │
   └──────────────────────────┘
            │
            ▼
   ┌──────────────────────────┐
   │  ecom_bookstore (MySQL)  │
   │  ┌─────────────────────┐ │
   │  │ users, books, cart  │ │
   │  │ categories, orders  │ │
   │  └─────────────────────┘ │
   └──────────────────────────┘
```

---

## 🔌 Flux requête-réponse

### Flux 1: Accès à la boutique

```
1. Utilisateur accède /index.php
2. PHP démarre la session
3. Inclut les classes (Auth, Book)
4. Crée instance Book
5. Appelle book->getAll(12, 0)
6. PDO exécute SELECT sur table books
7. Résultat retourné sous forme tableau
8. PHP génère HTML avec les livres
9. HTML envoyé au navigateur
```

**Fichiers impliqués**:
- `public/index.php` - Page
- `src/classes/Book.php` - Logique
- `src/config/Database.php` - Connexion

### Flux 2: Recherche AJAX

```
1. Utilisateur saisit "Dune" dans la recherche
2. JavaScript appelle fetch('/src/api/search.php?keyword=Dune')
3. search.php démarre session, inclut classes
4. Appelle book->search('Dune', null, null, null)
5. PDO prépare et exécute:
   SELECT * FROM books WHERE title LIKE '%Dune%'
6. Résultat renvoyé sous forme JSON
7. JavaScript reçoit JSON et met à jour le DOM
8. Page mise à jour sans rechargement
```

**Fichiers impliqués**:
- `public/assets/js/ajax.js` - Requête fetch
- `src/api/search.php` - Endpoint
- `src/classes/Book.php` - Logique search()

### Flux 3: Ajout au panier

```
1. Utilisateur clic "Ajouter au panier"
2. JavaScript POST à /src/api/add-to-cart.php
   Données: {book_id: 5, quantity: 2}
3. add-to-cart.php reçoit la requête
4. Vérifie que l'utilisateur est connecté
5. Crée instance Cart($pdo, $user_id)
6. Appelle cart->addItem(5, 2)
7. PDO vérifie:
   - Le livre existe
   - Le stock est suffisant
   - L'article n'existe pas dans le panier
8. Si tout OK, INSERT ou UPDATE
9. Retourne JSON: {success: true, message: "..."}
10. JavaScript met à jour le badge du panier
11. Affiche notification "Ajouté au panier"
```

**Fichiers impliqués**:
- `public/assets/js/cart.js` - Événement
- `src/api/add-to-cart.php` - Endpoint
- `src/classes/Cart.php` - Logique addItem()

---

## 🔐 Flux authentification

### Inscription

```
1. Utilisateur remplit le formulaire
2. Valide côté client (JavaScript optionnel)
3. POST /pages/register.php
4. PHP reçoit username, email, password
5. Appelle auth->register()
6. Vérifie les validations:
   - username length >= 3
   - email valid
   - password length >= 6
7. Requête SELECT: utilisateur existe?
8. Si existe: erreur
9. Si non existe:
   - Hash: bcrypt($password)
   - INSERT user: username, email, password_hash, role='user'
10. Retour: inscription réussie
11. Rediriger vers login
```

**Code**:
```php
$password_hash = password_hash($password, PASSWORD_DEFAULT);
$stmt = $pdo->prepare("
    INSERT INTO users (username, email, password_hash, role)
    VALUES (?, ?, ?, 'user')
");
$stmt->execute([$username, $email, $password_hash]);
```

### Connexion

```
1. Utilisateur saisit username et password
2. POST /pages/login.php
3. Appelle auth->login($username, $password)
4. SELECT user WHERE username = ?
5. Vérifie password_verify($password, $hash)
6. Si correct:
   - Crée $_SESSION['user_id']
   - Crée $_SESSION['username']
   - Crée $_SESSION['role']
   - Retourne success
7. Rediriger vers /index.php
8. Page "Bienvenue Jean" affichée
```

**Code**:
```php
$stmt = $pdo->prepare("SELECT * FROM users WHERE username = ?");
$stmt->execute([$username]);
$user = $stmt->fetch();

if (password_verify($password, $user['password_hash'])) {
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['role'] = $user['role'];
}
```

### Vérification d'accès

```
À chaque page protégée:
1. session_start()
2. if (!isset($_SESSION['user_id'])) { rediriger vers login }
3. Pour pages admin:
   if ($_SESSION['role'] !== 'admin') { rediriger }
```

---

## 📦 Classes métier

### Classe Database

**Rôle**: Gestion connexion MySQL

```php
$db = new Database();
$pdo = $db->connect();  // Retourne PDO object
```

**Responsabilités**:
- Établir connexion PDO
- Gérer les erreurs de connexion
- Configurer l'encodage UTF-8

### Classe Auth

**Rôle**: Gestion authentification

```php
$auth = new Auth($pdo);

// Inscription
$auth->register('jean', 'jean@email.com', 'password');

// Connexion
$auth->login('jean', 'password');

// Vérifications
$auth->isLoggedIn();
$auth->isAdmin();
$auth->getCurrentUser();

// Déconnexion
$auth->logout();
```

**Méthodes principales**:
- `register()` - Créer compte
- `login()` - Authentifier
- `logout()` - Déconnecter
- `isLoggedIn()` - Est connecté?
- `isAdmin()` - Est admin?

### Classe User

**Rôle**: Gestion données utilisateurs

```php
$user = new User($pdo);

// Récupérer
$user->getById(5);
$user->getAll();

// Modifier
$user->updateRole(5, 'admin');

// Supprimer
$user->delete(5);
```

**Responsabilités**:
- Récupérer infos utilisateur
- Modifier rôles
- Supprimer comptes (admin)

### Classe Book

**Rôle**: Gestion catalogue livres

```php
$book = new Book($pdo);

// Récupérer
$book->getAll(12, 0);           // 12 livres, offset 0
$book->getById(5);              // 1 livre

// Recherche
$book->search('dune', 1, 10, 30); // Dune, categorie 1, prix 10-30€

// Catégories
$book->getCategories();
$book->addCategory('Science-Fiction', 'Description');

// Admin
$book->create([...]);           // Créer
$book->update(5, [...]);        // Modifier
$book->delete(5);               // Supprimer
$book->count();                 // Total
```

**Responsabilités**:
- Récupérer livres
- Chercher/filtrer
- Gérer catégories (admin)
- CRUD (admin)

### Classe Cart

**Rôle**: Gestion panier utilisateur

```php
$cart = new Cart($pdo, $user_id);

// Ajouter
$cart->addItem(5, 2);           // Livre 5, quantité 2

// Voir
$cart->getItems();              // Tous les articles
$cart->getTotal();              // Total en €
$cart->getItemCount();          // Nombre articles

// Modifier
$cart->updateQuantity(3, 5);    // Article cart#3, new qty 5

// Supprimer
$cart->removeItem(3);           // Supprimer article
$cart->clear();                 // Vider le panier
```

**Responsabilités**:
- Ajouter articles
- Afficher panier
- Modifier quantités
- Calculer total
- Supprimer articles

---

## 🔄 Flux complet: Recherche et ajout au panier

```
UTILISATEUR
    │
    ├─→ Tape "Harry" dans la recherche
    │       (Front: /public/index.php)
    │
    ├─→ JavaScript capture l'événement
    │       (Fichier: /public/assets/js/ajax.js)
    │
    └─→ Appelle: fetch('/src/api/search.php?keyword=Harry')
            │
            ├─→ BACKEND: search.php
            │   ├─ session_start()
            │   ├─ Inclut Database.php, Book.php
            │   ├─ Crée: $book = new Book($pdo)
            │   ├─ Appelle: $book->search('Harry', null, null, null)
            │   │
            │   └─→ CLASSE Book::search()
            │       ├─ Prépare requête SQL:
            │       │  SELECT * FROM books WHERE title LIKE '%Harry%'
            │       ├─ Exécute: $stmt->execute(["%Harry%"])
            │       ├─ Récupère résultats: $stmt->fetchAll()
            │       └─ Retourne tableau de livres
            │
            ├─ Formatte résultat en JSON
            └─→ Envoie: {success: true, results: [...], count: 7}

    ├─→ JavaScript reçoit JSON
    │
    └─→ Appelle displayBooks(results)
            └─→ Met à jour le DOM
                    └─→ Affiche les 7 livres trouvés

UTILISATEUR
    │
    └─→ Clic sur "Harry Potter" → book-detail.php?id=3

                    DÉTAIL DU LIVRE
    
    │
    └─→ Clic "Ajouter au panier" (quantité: 2)
            │
            ├─→ JavaScript: addToCart(3, 2)
            │
            └─→ POST /src/api/add-to-cart.php
                {book_id: 3, quantity: 2}
                    │
                    ├─→ BACKEND: add-to-cart.php
                    │   ├─ session_start()
                    │   ├─ Vérifie: $_SESSION['user_id'] exists?
                    │   ├─ Crée: $cart = new Cart($pdo, $user_id)
                    │   └─ Appelle: $cart->addItem(3, 2)
                    │
                    └─→ CLASSE Cart::addItem()
                        ├─ Vérifie: livre existe?
                        ├─ Vérifie: stock >= 2?
                        ├─ Vérifie: article déjà dans panier?
                        ├─ Si article existe:
                        │   UPDATE cart SET quantity = quantity + 2
                        └─ Sinon:
                            INSERT INTO cart VALUES (user_id, 3, 2)

                    ├─ Retourne: {success: true, message: "..."}
    
    ├─→ JavaScript reçoit réponse
    │
    ├─→ Appelle: updateCartCount()
    │
    └─→ Affiche notification "Ajouté au panier"
            └─→ Badge du panier passe de 5 à 7
```

---

## 🚦 Points de validation

### 1. Validation des données

```php
// Avant toute requête, valider
if (empty($keyword)) {
    // Ignorer ou utiliser valeur par défaut
}

if ($quantity <= 0) {
    return ['success' => false, 'message' => 'Quantité invalide'];
}

if ($price < 0) {
    // Rejeter
}
```

### 2. Vérification permissions

```php
// Avant action admin
if (!$auth->isAdmin()) {
    echo json_encode(['success' => false]);
    exit;
}
```

### 3. Gestion erreurs

```php
// try/catch pour PDO
try {
    $stmt->execute([...]);
} catch (PDOException $e) {
    // Logger l'erreur (attention: ne pas révéler les détails au client)
    error_log($e->getMessage());
    return ['success' => false, 'message' => 'Erreur serveur'];
}
```

---

## 📝 Format des réponses API

### Succès
```json
{
    "success": true,
    "message": "Opération réussie",
    "data": {...},
    "count": 10
}
```

### Erreur
```json
{
    "success": false,
    "message": "Description de l'erreur"
}
```

### Liste de résultats
```json
{
    "success": true,
    "results": [
        {
            "id": 1,
            "title": "Livre 1",
            "price": 19.99
        }
    ],
    "count": 1
}
```

---

## 🔍 Trace debug

Pour debugger le flux:

1. **Vérifier les logs PHP**
   ```bash
   tail -f /var/log/php-fpm.log
   ```

2. **Ajouter des logs dans le code**
   ```php
   error_log("DEBUG: cart->addItem($book_id, $quantity)");
   ```

3. **Inspecteur navigateur**
   - DevTools > Network: voir requêtes
   - DevTools > Console: voir erreurs JS
   - DevTools > Application: voir cookies/sessions

4. **Vérifier la BD directement**
   ```sql
   SELECT * FROM cart WHERE user_id = 1;
   SELECT * FROM books WHERE id = 3;
   ```

---

**Architecture claire = code maintenable! 🏗️**
