# 📚 LibreBooks - E-Commerce académique

Un projet e-commerce fonctionnel développé en PHP vanilla (sans framework), conçu à des fins pédagogiques pour enseigner les principes du développement web.

## 🎯 Objectifs du projet

- ✅ Architecture Web complète (frontend / backend)
- ✅ Logique métier e-commerce (panier, commandes)
- ✅ Authentification et gestion des rôles (user / admin)
- ✅ Manipulation des sessions et cookies
- ✅ Base de données MySQL normalisée
- ✅ Requêtes AJAX pour une meilleure UX
- ✅ Web Services REST / API
- ✅ Bonnes pratiques de sécurité

## 🛠️ Technologies utilisées

- **Frontend**: HTML5, CSS3, JavaScript (vanilla)
- **Backend**: PHP 7+ (sans framework)
- **Base de données**: MySQL / MariaDB
- **API**: REST avec JSON
- **Sécurité**: PDO, prepared statements, bcrypt, sessions

## 📁 Structure du projet

```
e-com/
├── public/                 # Racine Web publique
│   ├── index.php          # Page d'accueil
│   ├── pages/
│   │   ├── login.php      # Connexion
│   │   ├── register.php   # Inscription
│   │   ├── book-detail.php # Détail du livre
│   │   ├── cart.php       # Panier
│   │   └── admin/
│   │       ├── dashboard.php
│   │       ├── add-book.php
│   │       └── manage-books.php
│   └── assets/
│       ├── css/
│       │   ├── style.css
│       │   └── admin.css
│       └── js/
│           ├── ajax.js
│           └── cart.js
├── src/                    # Code métier (non accessible web)
│   ├── config/
│   │   └── Database.php   # Configuration BD
│   ├── classes/
│   │   ├── Auth.php       # Authentification
│   │   ├── User.php       # Gestion utilisateurs
│   │   ├── Book.php       # Gestion livres
│   │   └── Cart.php       # Gestion panier
│   └── api/
│       ├── search.php
│       ├── add-to-cart.php
│       ├── remove-from-cart.php
│       ├── update-cart.php
│       ├── delete-book.php
│       └── update-user-role.php
├── database/
│   └── schema.sql         # Script de création BD
├── .gitignore
└── README.md

```

## 🚀 Installation et démarrage

### Prérequis

- PHP 7.4+ avec support PDO MySQL
- MySQL 5.7+ ou MariaDB 10.3+
- Serveur web (Apache, Nginx)
- Composer (optionnel)

### Étapes d'installation

1. **Cloner le projet**
   ```bash
   git clone <repo-url>
   cd e-com
   ```

2. **Créer la base de données**
   ```bash
   mysql -u root -p < database/schema.sql
   ```
   
   Ou importer le fichier `schema.sql` via phpMyAdmin

3. **Configurer la connexion BD**
   
   Éditer `src/config/Database.php` avec vos identifiants MySQL:
   ```php
   private $host = 'localhost';
   private $db_name = 'ecom_bookstore';
   private $username = 'root';
   private $password = '';
   ```

4. **Lancer le serveur (PHP intégré)**
   ```bash
   cd public
   php -S localhost:8000
   ```
   
   Accès: http://localhost:8000

## 🔐 Comptes de test

### Admin
- **Identifiant**: admin
- **Mot de passe**: admin123
- **Accès**: http://localhost:8000/pages/admin/dashboard.php

### Utilisateur
- **Identifiant**: jean.dupont
- **Mot de passe**: password123

## ✨ Fonctionnalités principales

### 1. Boutique 🏪
- Affichage de tous les livres
- Recherche et filtrage par titre, auteur, catégorie, prix
- Pagination (12 livres par page)
- AJAX pour le filtrage en temps réel

### 2. Détail du livre 📖
- Page dédiée par livre
- Description complète, prix, stock
- Ajout au panier
- Gestion des quantités

### 3. Authentification 🔑
- Inscription avec validation
- Connexion sécurisée (bcrypt)
- Gestion des sessions PHP
- Cookies de persistance
- Déconnexion

### 4. Panier 🛒
- Ajouter/supprimer des articles
- Modifier les quantités
- Calcul du total
- Sauvegarde en base de données

### 5. Administration 👨‍💼
- **Accès protégé** (vérification rôle côté serveur)
- **Gestion des livres**
  - Ajouter un nouveau livre
  - Modifier un livre existant
  - Supprimer un livre
- **Gestion des utilisateurs**
  - Voir tous les utilisateurs
  - Promouvoir/rétrogader en admin
- **Tableau de bord** avec statistiques

## 🔒 Sécurité

### Implémentée

✅ **Prévention SQL Injection**
- Utilisation de prepared statements (PDO)
- Validation et échappement des entrées

✅ **Authentification sécurisée**
- Mots de passe hashés avec bcrypt (PASSWORD_DEFAULT)
- Vérification avec password_verify()

✅ **Gestion des sessions**
- session_start() à chaque page protégée
- Vérification de l'utilisateur connecté
- Destruction de session à la déconnexion

✅ **Contrôle d'accès**
- Vérification du rôle (user/admin) côté serveur
- Les pages admin redirectionnent si pas admin

✅ **Autre**
- Échappement des données HTML (htmlspecialchars)
- En-têtes Content-Type appropriés

## 📡 API REST

Toutes les requêtes retournent du JSON.

### Endpoints

#### Recherche
```
POST/GET /src/api/search.php
Paramètres: keyword, category_id, min_price, max_price
Réponse: {success: bool, results: array, count: int}
```

#### Panier
```
POST /src/api/add-to-cart.php
Paramètres: book_id, quantity
Réponse: {success: bool, message: string}

POST /src/api/update-cart.php
Paramètres: cart_id, quantity

POST /src/api/remove-from-cart.php
Paramètres: cart_id

GET /src/api/get-cart-count.php
Réponse: {success: bool, count: int}
```

#### Admin
```
POST /src/api/delete-book.php (require admin)
Paramètres: book_id

POST /src/api/update-user-role.php (require admin)
Paramètres: user_id, role
```

## 🗄️ Schéma de base de données

### Tables

| Table | Description |
|-------|------------|
| **users** | Utilisateurs (id, username, email, role) |
| **categories** | Catégories de livres |
| **books** | Livres/Produits |
| **cart** | Panier (user_id, book_id, quantity) |
| **orders** | Commandes (bonus) |
| **order_items** | Détail des commandes (bonus) |

### Relations
- users (1) -> (N) cart
- categories (1) -> (N) books
- books (1) -> (N) cart
- users (1) -> (N) orders
- orders (1) -> (N) order_items

## 📝 Notes sur le code

### Bonnes pratiques appliquées

1. **Architecture MVC-like**
   - Séparation logique métier / présentation
   - Classes métier dans `src/classes/`
   - Pages de présentation dans `public/pages/`

2. **Gestion d'erreurs**
   - try/catch pour les exceptions PDO
   - Messages d'erreur informatifs
   - Logging des erreurs (à implémenter)

3. **Validation**
   - Validation côté serveur (jamais faire confiance au client)
   - Vérification des permissions avant action

4. **Commentaires**
   - Code commenté en français
   - Explications des blocs principaux

5. **DRY (Don't Repeat Yourself)**
   - Fonctions réutilisables en JavaScript
   - Classes PHP pour la logique commune

## 🔧 Configuration personnalisée

### Ajouter une nouvelle catégorie

```php
$book = new Book($pdo);
$book->addCategory('Titre', 'Description');
```

### Ajouter un livre (admin)

```php
$data = [
    'title' => 'Mon Livre',
    'author' => 'Auteur',
    'description' => '...',
    'isbn' => '...',
    'publisher' => '...',
    'category_id' => 1,
    'price' => 19.99,
    'stock' => 50,
    'pages' => 300,
    'publication_year' => 2024,
    'cover_image' => 'url'
];
$book = new Book($pdo);
$book->create($data);
```

## 📊 Améliorations possibles

- [ ] Système de paiement (Stripe, PayPal)
- [ ] Avis et évaluations des livres
- [ ] Recherche avancée (full-text)
- [ ] Historique des commandes
- [ ] Notifications par email
- [ ] Cache (Redis/Memcached)
- [ ] Tests unitaires (PHPUnit)
- [ ] Logging complet (Monolog)
- [ ] API Documentation (OpenAPI/Swagger)
- [ ] Déploiement (Docker, CI/CD)

## 🎓 Points d'apprentissage

### Frontend
- ✅ HTML sémantique
- ✅ CSS responsive (Grid, Flexbox)
- ✅ JavaScript vanilla (fetch, DOM manipulation)
- ✅ AJAX sans dépendances

### Backend
- ✅ PHP OOP (classes, héritage, interfaces)
- ✅ PDO et requêtes préparées
- ✅ Sessions et cookies
- ✅ Authentification et autorisation
- ✅ Architecture logicielle basique

### Base de données
- ✅ Normalisation (3NF)
- ✅ Clés étrangères et intégrité référentielle
- ✅ Index et optimisation
- ✅ Transactions (à améliorer)

### Outils
- ✅ Git et gestion des versions
- ✅ MySQL/phpMyAdmin
- ✅ Outils de développement du navigateur

## 📚 Ressources pédagogiques

### Livres
- *Clean Code* - Robert Martin
- *The Pragmatic Programmer*
- *PHP: The Right Way*

### Documentations
- [PHP.net - PDO](https://www.php.net/manual/en/book.pdo.php)
- [MDN Web Docs - JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
- [MDN Web Docs - HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP)
- [MySQL Documentation](https://dev.mysql.com/doc/)

## 🤝 Contribution et améliorations

Ce projet est un support pédagogique. Les améliorations suggérées :

1. Créer une branche pour chaque fonctionnalité
2. Faire des commits atomiques et explicites
3. Ajouter des commentaires pour l'apprentissage
4. Tester avant de fusionner

## 📜 Licence

MIT - Projet académique libre d'utilisation

## 👨‍🎓 Auteur

Développé comme projet académique de démonstration.

---

**Bon développement ! 🚀**
