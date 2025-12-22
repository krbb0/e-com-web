# 🚀 Guide de démarrage - LibreBooks

Ce fichier guide les étapes essentielles pour mettre en place le projet e-commerce.

## ⚡ Démarrage rapide (5 minutes)

### 1. Base de données
```bash
# Importer le schéma SQL
mysql -u root -p < database/schema.sql
```

### 2. Configurer PHP (si besoin)
Éditer `src/config/Database.php` avec vos paramètres MySQL:
```php
private $host = 'localhost';        // ou 127.0.0.1
private $db_name = 'ecom_bookstore';
private $username = 'root';         // votre user MySQL
private $password = '';             // votre password MySQL
```

### 3. Lancer le serveur
```bash
cd public
php -S localhost:8000
```

### 4. Accéder à l'application
- **Boutique**: http://localhost:8000
- **Admin**: http://localhost:8000/pages/admin/dashboard.php

---

## 🔐 Comptes par défaut

### Administrateur
```
Username: admin
Password: admin123
```

### Utilisateur test
```
Username: jean.dupont
Password: password123
```

**Note**: Ces comptes sont créés lors de l'import de `schema.sql`. Pour ajouter d'autres admin, modifier le script SQL ou promouvoir via le dashboard.

---

## 📋 Checklist de configuration

- [ ] PHP 7.4+ installé
- [ ] MySQL/MariaDB en cours d'exécution
- [ ] Script SQL importé (`schema.sql`)
- [ ] Credentials MySQL configurées dans `Database.php`
- [ ] Serveur PHP lancé
- [ ] Page d'accueil accessible
- [ ] Connexion admin fonctionnelle
- [ ] Ajout d'un livre depuis admin

---

## 🔧 Dépannage

### Erreur de connexion à la BD
```
Erreur de connexion: SQLSTATE[HY000]...
```
**Solution**: Vérifier les credentials dans `src/config/Database.php`

### Sessions non persistantes
**Solution**: Vérifier que `session.save_path` est accessible en écriture

### Styles CSS non chargés
**Solution**: Vérifier les chemins relatifs dans le navigateur (DevTools > Network)

### API AJAX ne fonctionne pas
**Solution**: 
- Vérifier la console du navigateur (DevTools > Console)
- Vérifier que l'utilisateur est connecté
- Vérifier les réponses du serveur (DevTools > Network)

---

## 📊 Architecture du flux

```
Visiteur non connecté
  ↓
  ├─→ Voir boutique (sans détails)
  ├─→ S'inscrire
  └─→ Se connecter

Utilisateur connecté
  ↓
  ├─→ Rechercher/filtrer livres (AJAX)
  ├─→ Voir détail d'un livre
  ├─→ Ajouter au panier (AJAX)
  ├─→ Voir panier
  ├─→ Modifier quantités
  └─→ Passer commande

Administrateur
  ↓
  ├─→ Tableau de bord (stats)
  ├─→ Ajouter livre
  ├─→ Modifier/Supprimer livre
  └─→ Gérer utilisateurs (rôles)
```

---

## 🎯 Premiers pas recommandés

### 1. Tester les fonctionnalités basiques
- [ ] Inscription d'un nouvel utilisateur
- [ ] Connexion
- [ ] Recherche/filtrage (AJAX)
- [ ] Ajout au panier
- [ ] Panier et modification de quantités

### 2. Tester l'administration
- [ ] Connexion en tant qu'admin
- [ ] Ajouter un nouveau livre
- [ ] Modifier un livre
- [ ] Supprimer un livre
- [ ] Promouvoir un utilisateur en admin

### 3. Tester la sécurité
- [ ] Essayer d'accéder à /admin sans être admin
- [ ] Essayer d'accéder au panier sans être connecté
- [ ] Vérifier les mots de passe hashés dans la BD

---

## 📝 Notes importantes

### Sécurité

⚠️ **Pour la production:**
- Générer de nouveaux mots de passe admin forts
- Utiliser des variables d'environnement (.env) pour les credentials
- Activer HTTPS
- Ajouter des CSRF tokens
- Implémenter rate limiting

### Performance

💡 **Pour l'optimisation:**
- Ajouter du cache (Redis)
- Implémenter la pagination côté server
- Utiliser des prepared statements (✅ déjà fait)
- Optimiser les images
- Minifier CSS/JS

### Maintenabilité

🏗️ **Structure professionnelle:**
- Le code est prêt pour l'apprentissage
- Ajouter des tests avec PHPUnit
- Implémenter un système de log
- Ajouter de la documentation API (OpenAPI)
- Mettre en place CI/CD

---

## 🎓 Concepts clés à comprendre

1. **Sessions PHP**
   - Fichier: Chaque page protégée commence par `session_start()`
   - Les données utilisateur sont dans `$_SESSION`

2. **Base de données**
   - PDO avec prepared statements pour la sécurité
   - Classes métier (Book, Cart, User, Auth)

3. **API REST**
   - Routes en `/src/api/`
   - Réponses en JSON
   - Vérification d'authentification côté serveur

4. **Frontend interactif**
   - JavaScript vanilla (pas de jQuery/framework)
   - AJAX avec `fetch()` API
   - Validation côté client (UX) et serveur (sécurité)

---

## 📚 Prochaines étapes pédagogiques

1. **Ajouter des commentaires** dans le code
2. **Créer des cas de test** (manuel ou automatisé)
3. **Implémenter un système de log**
4. **Ajouter des notifications email**
5. **Créer une API Swagger/OpenAPI**
6. **Dockeriser l'application**
7. **Ajouter des tests PHPUnit**
8. **Mettre en place un workflow Git**

---

## 🆘 Support

En cas de problème:
1. Vérifier les logs du serveur PHP
2. Vérifier la console du navigateur (DevTools)
3. Vérifier les logs MySQL
4. Vérifier les fichiers de configuration
5. Consulter le README.md pour plus de détails

---

**Bon développement ! 🚀**
