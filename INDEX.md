# 📇 INDEX - Tous les fichiers du projet

## 📊 Vue d'ensemble

**Total**: 34 fichiers créés
- 13 fichiers PHP (pages + API)
- 5 classes PHP
- 1 fichier config PHP
- 7 documentations Markdown
- 2 fichiers SQL
- 2 fichiers CSS
- 2 fichiers JavaScript
- 1 fichier .gitignore

---

## 🚀 Démarrage (LIRE D'ABORD)

1. **[README.md](README.md)** - Documentation générale (fonctionnalités, installation)
2. **[QUICKSTART.md](QUICKSTART.md)** - Démarrage en 5 minutes
3. **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Récapitulatif complet du projet

---

## 📖 Documentation

| Fichier | Contenu | Lecture |
|---------|---------|---------|
| [README.md](README.md) | Documentation générale | ⭐ PREMIÈRE |
| [QUICKSTART.md](QUICKSTART.md) | Guide de démarrage rapide | ⭐ DEUXIÈME |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | Résumé du projet | 5 min |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Explication backend détaillée | 10 min |
| [SECURITY.md](SECURITY.md) | Sécurité et bonnes pratiques | 10 min |
| [GIT_GUIDE.md](GIT_GUIDE.md) | Workflow Git pour équipe | 8 min |
| [TESTING.md](TESTING.md) | Guide complet de test | 15 min |

---

## 🔌 Code PHP - Configuration

### `src/config/Database.php`
- Connexion MySQL avec PDO
- Gestion erreurs
- Configuration centralisée

**À modifier**: Identifiants MySQL

---

## 🔌 Code PHP - Classes métier

### `src/classes/Auth.php`
- `register()` - Créer un compte
- `login()` - Authentifier utilisateur
- `logout()` - Déconnecter
- `isLoggedIn()` - Est connecté?
- `isAdmin()` - Est admin?

### `src/classes/User.php`
- `getById()` - Récupérer un user
- `getAll()` - Tous les users
- `updateRole()` - Changer rôle
- `delete()` - Supprimer compte

### `src/classes/Book.php`
- `getAll()` - Tous les livres
- `getById()` - Un livre
- `search()` - Recherche/filtrage
- `create()` - Ajouter (admin)
- `update()` - Modifier (admin)
- `delete()` - Supprimer (admin)
- `getCategories()` - Catégories
- `addCategory()` - Ajouter catégorie

### `src/classes/Cart.php`
- `addItem()` - Ajouter article
- `getItems()` - Voir panier
- `getTotal()` - Total en €
- `updateQuantity()` - Modifier quantité
- `removeItem()` - Supprimer article
- `clear()` - Vider panier

---

## 🔌 Code PHP - Pages publiques

### `public/index.php`
- Page d'accueil / Boutique
- Affiche tous les livres
- Inclut barre latérale filtres

### `public/pages/login.php`
- Formulaire connexion
- Validation entrées
- Gestion sessions

### `public/pages/register.php`
- Formulaire inscription
- Validation complète
- Hash mot de passe bcrypt

### `public/pages/book-detail.php`
- Détail d'un livre
- Données complètes
- Bouton "Ajouter au panier"

### `public/pages/cart.php`
- Affiche panier
- Modification quantités
- Suppression articles
- Calcul total

---

## 🔌 Code PHP - Pages admin

### `public/pages/admin/dashboard.php`
- Tableau de bord
- Statistiques (livres, users, catégories)
- Gestion utilisateurs
- Gestion livres (aperçu)

### `public/pages/admin/add-book.php`
- Formulaire ajout livre
- Tous les champs
- Validation serveur

### `public/pages/admin/manage-books.php`
- Liste tous les livres
- Boutons Éditer/Supprimer
- Formulaire édition (si ?id=X)

---

## 🔌 Code PHP - API REST

### `src/api/search.php`
- **Méthode**: GET/POST
- **Paramètres**: keyword, category_id, min_price, max_price
- **Réponse**: JSON {success, results, count}

### `src/api/add-to-cart.php`
- **Méthode**: POST
- **Paramètres**: book_id, quantity
- **Réponse**: JSON {success, message}

### `src/api/remove-from-cart.php`
- **Méthode**: POST
- **Paramètres**: cart_id
- **Réponse**: JSON {success, message}

### `src/api/update-cart.php`
- **Méthode**: POST
- **Paramètres**: cart_id, quantity
- **Réponse**: JSON {success, message}

### `src/api/get-cart-count.php`
- **Méthode**: GET
- **Réponse**: JSON {success, count}

### `src/api/delete-book.php` ⚠️ Admin
- **Méthode**: POST
- **Paramètres**: book_id
- **Réponse**: JSON {success, message}

### `src/api/update-user-role.php` ⚠️ Admin
- **Méthode**: POST
- **Paramètres**: user_id, role
- **Réponse**: JSON {success, message}

---

## 🎨 Frontend - CSS

### `public/assets/css/style.css` (~600 lignes)
- Réinitialisation (*)
- Navigation (navbar)
- Héro section
- Boutons (btn-primary, btn-secondary, etc.)
- Formulaires
- Alertes
- Boutique (grille, filtres, pagination)
- Détail livre
- Panier
- Pages authentification
- Footer
- Animations (slideIn, slideOut)
- Media queries (responsive)

### `public/assets/css/admin.css` (~200 lignes)
- Navbar admin (sombre)
- Containers admin
- Cartes statistiques
- Tableaux admin
- Formulaires admin
- Role badges
- Media queries

---

## 🎨 Frontend - JavaScript

### `public/assets/js/ajax.js`
- `debounce()` - Éviter trop de requêtes
- `applyFilters()` - Appliquer filtres
- `resetFilters()` - Réinitialiser
- `displayBooks()` - Afficher les livres
- `updateCartCount()` - Badge panier

### `public/assets/js/cart.js`
- `loadCartCount()` - Charger count au démarrage
- `addToCart()` - Ajouter article (fetch)
- `showNotification()` - Afficher message

---

## 🗄️ Base de données - SQL

### `database/schema.sql`
```sql
-- Tables
users              -- Utilisateurs (id, username, email, password_hash, role)
categories         -- Catégories de livres
books              -- Livres (produits)
cart               -- Panier (user_id, book_id, quantity)
orders             -- Commandes (bonus)
order_items        -- Détail commandes (bonus)

-- Données de test
- 6 catégories
- 10 livres
- 2 utilisateurs (admin + user)
```

### `database/TEST_QUERIES.sql`
- Vérifications basiques
- Tests de données
- Statistiques
- Maintenance
- Sécurité

---

## 🔐 Configuration et Git

### `.gitignore`
Fichiers à ignorer:
- .env (credentials)
- vendor/ (dépendances)
- uploads/ (fichiers utilisateur)
- .DS_Store, Thumbs.db (OS)
- *.log (logs)

**À utiliser**: `git add .` en confiance

---

## 📋 Résumé par catégorie

### Frontend (HTML + CSS + JS)
- **Pages**: 8 pages PHP (accueil, login, register, détail, panier, admin x3)
- **CSS**: 2 fichiers (general + admin)
- **JS**: 2 fichiers (AJAX + Cart)

### Backend (PHP)
- **Classes**: 4 classes (Auth, User, Book, Cart)
- **Config**: 1 fichier (Database)
- **API**: 7 endpoints REST
- **Sécurité**: PDO, bcrypt, sessions, validation

### Base de données
- **Tables**: 6 tables normalisées
- **Données**: 10 livres, 6 catégories, 2 users
- **Tests**: Scripts de vérification

### Documentation
- **7 Markdown** documentations complètes
- **Couvre**: Installation, architecture, sécurité, tests, Git

---

## 🎯 Ordre de lecture recommandé

### Pour débuter rapidement (5 min)
1. README.md
2. QUICKSTART.md
3. Lancer le projet

### Pour comprendre le fonctionnement (30 min)
1. ARCHITECTURE.md (backend)
2. Lire quelques classes PHP
3. Tester les fonctionnalités

### Pour la sécurité (15 min)
1. SECURITY.md
2. Identifier les points à renforcer

### Pour collaborer (15 min)
1. GIT_GUIDE.md
2. Commencer à commiter

### Pour tester complètement (1-2h)
1. TESTING.md
2. Exécuter les 34 cas de test

---

## 🔄 Flux d'utilisation

```
Utilisateur
   ↓
├─→ Voir boutique (index.php)
├─→ Rechercher/filtrer (AJAX via search.php)
├─→ Voir détail livre (book-detail.php)
├─→ Ajouter panier (AJAX via add-to-cart.php)
├─→ Voir panier (cart.php)
├─→ Modifier quantités (AJAX via update-cart.php)
├─→ Passer commande
├─→ Connexion (login.php)
├─→ Inscription (register.php)
└─→ Déconnexion

Admin (avec accès supplémentaire)
   ↓
├─→ Dashboard (admin/dashboard.php)
├─→ Ajouter livre (admin/add-book.php)
├─→ Modifier livre (admin/manage-books.php)
├─→ Supprimer livre (via delete-book.php API)
└─→ Gérer utilisateurs (changer rôles)
```

---

## 📊 Statistiques

| Métrique | Valeur |
|----------|--------|
| Total fichiers | 34 |
| Fichiers PHP | 13 |
| Classes PHP | 4 |
| Endpoints API | 7 |
| Pages web | 8 |
| Lignes CSS | ~800 |
| Lignes JavaScript | ~200 |
| Lignes SQL | ~300 |
| Documentations | 7 |
| Fichiers configuration | 2 |

---

## ✅ Checklist Installation

- [ ] Cloner le projet
- [ ] Importer `database/schema.sql`
- [ ] Configurer `src/config/Database.php`
- [ ] Lancer PHP: `php -S localhost:8000`
- [ ] Accéder à http://localhost:8000
- [ ] Tester connexion admin
- [ ] Lire [QUICKSTART.md](QUICKSTART.md)
- [ ] Lire [README.md](README.md)
- [ ] Lancer les tests ([TESTING.md](TESTING.md))

---

## 🚀 Commandes principales

```bash
# Importer BD
mysql -u root -p < database/schema.sql

# Lancer serveur
cd public && php -S localhost:8000

# Accéder à l'app
http://localhost:8000

# Admin
http://localhost:8000/pages/admin/dashboard.php
```

---

## 📞 Support

En cas de problème:
1. Vérifier [QUICKSTART.md](QUICKSTART.md) - "Dépannage"
2. Vérifier [TESTING.md](TESTING.md) - "Débogage"
3. Lancer les scripts SQL [database/TEST_QUERIES.sql](database/TEST_QUERIES.sql)
4. Vérifier les logs PHP/MySQL

---

**Tous les fichiers sont prêts à l'emploi! 🚀**

C'est maintenant au votre de développer et d'apprendre! 📚

---

*Créé pour l'apprentissage - Décembre 2025*
