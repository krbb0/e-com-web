# 🧪 Guide de test - LibreBooks

Guide pratique pour tester toutes les fonctionnalités du projet.

## ✅ Checklist complète

### 1. Installation et base de données

- [ ] MySQL/MariaDB en cours d'exécution
- [ ] Base de données créée (`ecom_bookstore`)
- [ ] Tables créées avec le schéma
- [ ] Données de test importées
- [ ] Utilisateurs de test présents

**Vérification**:
```bash
mysql -u root -p
use ecom_bookstore;
SELECT COUNT(*) FROM users;        -- Doit retourner >= 2
SELECT COUNT(*) FROM books;        -- Doit retourner >= 10
SELECT COUNT(*) FROM categories;   -- Doit retourner >= 6
```

### 2. Configuration PHP

- [ ] Database.php configurée avec les bons identifiants
- [ ] PHP version >= 7.4
- [ ] Extension PDO activée
- [ ] Sessions activées

**Vérification**:
```bash
php -v
php -m | grep -i pdo
php -m | grep -i session
```

### 3. Serveur web

- [ ] Serveur lancé sur http://localhost:8000
- [ ] Racine web pointant sur le dossier `public/`

**Commande**:
```bash
cd public
php -S localhost:8000
```

---

## 🧪 Tests fonctionnels

### Test 1: Page d'accueil

**URL**: http://localhost:8000

**À vérifier**:
- [ ] Page charge sans erreur
- [ ] Navbar affichée
- [ ] Héro section visible
- [ ] Livres affichés en grille
- [ ] Pagination affichée (si > 12 livres)

**Attendu**: 
- Voir les 12 premiers livres
- Boutons "Voir détails" actifs
- Pas de messages d'erreur

---

### Test 2: Navigation et menus

**À vérifier**:
- [ ] Logo cliquable → retour accueil
- [ ] Lien "Accueil" fonctionne
- [ ] Lien "Connexion" affichée si déconnecté
- [ ] Lien "Inscription" affichée si déconnecté
- [ ] Lien "Panier" affichée si connecté
- [ ] Compteur panier = 0 initialement

---

### Test 3: Inscription

**URL**: http://localhost:8000/pages/register.php

**Test 3a: Inscription valide**
```
Username: test.user
Email: test@example.com
Password: password123
Confirm: password123
```

**Résultat attendu**:
- [ ] Message "Inscription réussie!"
- [ ] Redirection vers login (optionnel)
- [ ] Nouvel utilisateur visible en BD

**Test 3b: Validation - Username court**
```
Username: ab
```
**Résultat attendu**: Erreur "trop court"

**Test 3c: Validation - Email invalide**
```
Email: notanemail
```
**Résultat attendu**: Erreur "Email invalide"

**Test 3d: Validation - Mots de passe différents**
```
Password: password123
Confirm: password456
```
**Résultat attendu**: Erreur "ne correspondent pas"

**Test 3e: Validation - Username déjà utilisé**
```
Username: admin
```
**Résultat attendu**: Erreur "déjà utilisé"

---

### Test 4: Connexion

**URL**: http://localhost:8000/pages/login.php

**Test 4a: Connexion valide (admin)**
```
Username: admin
Password: admin123
```

**Résultat attendu**:
- [ ] Message "Connexion réussie"
- [ ] Redirection vers accueil
- [ ] Navbar affiche "Bienvenue admin"
- [ ] Lien "Admin" visible en rouge
- [ ] Lien "Déconnexion" visible

**Test 4b: Connexion valide (user)**
```
Username: jean.dupont
Password: password123
```

**Résultat attendu**:
- [ ] Navbar affiche "Bienvenue jean.dupont"
- [ ] Lien "Admin" NON visible (user, pas admin)

**Test 4c: Mauvais mot de passe**
```
Username: admin
Password: wrongpassword
```

**Résultat attendu**: Erreur "Mot de passe incorrect"

**Test 4d: User n'existe pas**
```
Username: nonexistent
```

**Résultat attendu**: Erreur "Utilisateur non trouvé"

---

### Test 5: Recherche et filtrage (AJAX)

**Prérequis**: Être connecté

**Test 5a: Recherche par titre**
```
Saisir "Dune" dans le champ recherche
```

**Résultat attendu**:
- [ ] Page NE se recharge PAS
- [ ] Résultats changent en temps réel
- [ ] Affiche le livre "Dune" seul
- [ ] Compte affiche "1 résultat"

**Test 5b: Recherche par auteur**
```
Saisir "Asimov"
```

**Résultat attendu**:
- [ ] Affiche "Fondation" (par Asimov)

**Test 5c: Filtrer par catégorie**
```
Sélectionner "Science-Fiction"
Cliquer "Appliquer filtres"
```

**Résultat attendu**:
- [ ] Affiche uniquement livres Science-Fiction
- [ ] Compte correct

**Test 5d: Filtrer par prix**
```
Prix min: 15
Prix max: 25
Appliquer
```

**Résultat attendu**:
- [ ] Affiche livres entre 15€ et 25€

**Test 5e: Réinitialiser**
```
Cliquer "Réinitialiser"
```

**Résultat attendu**:
- [ ] Page se recharge
- [ ] Tous les filtres vidés
- [ ] Tous les livres réaffichés

---

### Test 6: Détail du livre

**Test 6a: Accéder à un livre**
```
Cliquer sur un livre depuis la grille
```

**Résultat attendu**:
- [ ] Page détail charge
- [ ] URL: /pages/book-detail.php?id=X
- [ ] Titre du livre affiché
- [ ] Auteur affiché
- [ ] ISBN, éditeur, année affichés
- [ ] Description affichée
- [ ] Prix grand format affiché
- [ ] Stock affiché ("En stock" ou "Rupture")
- [ ] Bouton "Ajouter au panier" présent

**Test 6b: Détail non existant**
```
URL: /pages/book-detail.php?id=99999
```

**Résultat attendu**:
- [ ] Redirection vers accueil
- [ ] Pas d'erreur

---

### Test 7: Panier (AJAX)

**Prérequis**: Être connecté, avoir un livre à ajouter

**Test 7a: Ajouter au panier**
```
Depuis la page détail d'un livre:
Quantité: 1
Cliquer "Ajouter au panier"
```

**Résultat attendu**:
- [ ] Notification "Ajouté au panier"
- [ ] Badge panier passe de 0 à 1
- [ ] Notification disparaît après 3s

**Test 7b: Ajouter plusieurs fois le même livre**
```
Ajouter "Harry Potter" avec qty 2
Puis ajouter "Harry Potter" avec qty 1
```

**Résultat attendu**:
- [ ] Quantité totale = 3 (pas 2 articles)
- [ ] Badge = 1 (1 article différent)

**Test 7c: Ajouter plusieurs livres**
```
Ajouter Livre A (qty 2)
Ajouter Livre B (qty 1)
```

**Résultat attendu**:
- [ ] Badge = 2 (2 articles différents)

---

### Test 8: Page panier

**URL**: http://localhost:8000/pages/cart.php

**Test 8a: Voir le panier**
**Résultat attendu**:
- [ ] Tous les articles affichés
- [ ] Tableau avec: Livre, Prix, Quantité, Sous-total
- [ ] Total calculé correctement
- [ ] Résumé affiché

**Test 8b: Modifier quantité**
```
Changer quantité d'un article de 2 à 3
Actualiser
```

**Résultat attendu**:
- [ ] Quantité mise à jour
- [ ] Sous-total recalculé
- [ ] Total recalculé

**Test 8c: Supprimer un article**
```
Cliquer "Supprimer" sur un article
Confirmer
```

**Résultat attendu**:
- [ ] Article supprimé
- [ ] Panier recalculé
- [ ] Badge mis à jour
- [ ] Page recharger

**Test 8d: Panier vide**
```
Supprimer tous les articles
```

**Résultat attendu**:
- [ ] Message "Panier vide"
- [ ] Bouton "Continuer vos achats"
- [ ] Tableau disparaît

---

### Test 9: Administration - Accès

**Prérequis**: Être connecté en admin

**Test 9a: Accès admin (connecté)**
```
URL: /pages/admin/dashboard.php
```

**Résultat attendu**:
- [ ] Page charge
- [ ] Lien "Admin" visible et actif (rouge)
- [ ] Tableau de bord affichée

**Test 9b: Accès admin (non connecté)**
```
Déconnecter
URL: /pages/admin/dashboard.php
```

**Résultat attendu**:
- [ ] Redirection vers /pages/login.php

**Test 9c: Accès admin (user normal)**
```
Connecter en tant que jean.dupont
URL: /pages/admin/dashboard.php
```

**Résultat attendu**:
- [ ] Redirection vers /index.php

---

### Test 10: Administration - Ajouter un livre

**URL**: /pages/admin/add-book.php

**Test 10a: Ajouter un livre valide**
```
Titre: Mon Nouveau Livre
Auteur: Jean Auteur
Prix: 24.99
Stock: 50
Catégorie: Fantasy
Description: Une belle histoire
```

**Résultat attendu**:
- [ ] Message "Livre ajouté avec succès!"
- [ ] Formulaire réinitialisé
- [ ] Livre visible dans "Gérer les livres"
- [ ] Livre visible dans la boutique

**Test 10b: Validation - Titre manquant**
```
Laisser titre vide
Cliquer "Ajouter"
```

**Résultat attendu**: Erreur "obligatoires"

**Test 10c: Validation - Prix invalide**
```
Prix: 0 ou -5
```

**Résultat attendu**: Erreur "Prix doit être > 0"

---

### Test 11: Administration - Modifier un livre

**URL**: /pages/admin/manage-books.php

**Test 11a: Modifier les détails**
```
Cliquer "Éditer" sur un livre
Modifier le titre
Cliquer "Sauvegarder"
```

**Résultat attendu**:
- [ ] Message "Livre modifié avec succès"
- [ ] Changement visible en boutique

**Test 11b: Modifier le stock**
```
Changer stock de 50 à 100
Sauvegarder
```

**Résultat attendu**:
- [ ] Stock modifié en BD
- [ ] "En stock" toujours affiché (si > 0)

---

### Test 12: Administration - Supprimer un livre

**URL**: /pages/admin/manage-books.php

**Test 12a: Supprimer un livre**
```
Cliquer "Supprimer"
Confirmer
```

**Résultat attendu**:
- [ ] Page recharge
- [ ] Livre disparu de la liste
- [ ] Livre disparu de la boutique
- [ ] Les paniers contenant ce livre restent (article à gérer)

---

### Test 13: Sécurité

**Test 13a: SQL Injection**
```
Page login:
Username: admin' OR '1'='1
```

**Résultat attendu**:
- [ ] Erreur "Utilisateur non trouvé"
- [ ] Pas de login sans bon mot de passe

**Test 13b: XSS**
```
Recherche: <script>alert('xss')</script>
```

**Résultat attendu**:
- [ ] Script n'exécute PAS
- [ ] Texte affiché comme normal

**Test 13c: Modification de session**
```
DevTools > Application > Cookies
Modifier PHPSESSID
Rafraîchir
```

**Résultat attendu**:
- [ ] Session invalide
- [ ] Redirection vers login

---

### Test 14: Déconnexion

```
Cliquer "Déconnexion"
```

**Résultat attendu**:
- [ ] Session détruite
- [ ] Redirection vers accueil
- [ ] Navbar: "Connexion" et "Inscription" visibles
- [ ] Lien "Admin" disparu
- [ ] Badge panier disparu

---

## 🐛 Débogage

### Erreur: Connexion BD échouée

```
Erreur: SQLSTATE[HY000]...
```

**Solutions**:
1. Vérifier MySQL en cours
2. Vérifier identifiants dans Database.php
3. Vérifier nom de la BD: `ecom_bookstore`

### Erreur: Sessions non fonctionnelles

```
$_SESSION vide après connexion
```

**Solutions**:
1. Vérifier `session_start()` en haut du fichier
2. Vérifier droits d'accès dossier `/tmp`
3. Vérifier php.ini: session.save_path

### Erreur: Styles CSS manquants

```
Page sans CSS (style blanc/noir)
```

**Solutions**:
1. DevTools > Network: vérifier 404 sur style.css
2. Vérifier chemin relatif `/assets/css/style.css`
3. Vérifier fichier existe

### Erreur: AJAX non fonctionnelle

```
Recherche ne met pas à jour les résultats
```

**Solutions**:
1. DevTools > Console: voir les erreurs JS
2. DevTools > Network: voir réponse API
3. Vérifier l'utilisateur est connecté
4. Vérifier fetch() utilise bon URL

---

## 📊 Rapport de test

Utiliser ce modèle pour documenter les tests:

```
TEST: [nom du test]
DATE: YYYY-MM-DD
NAVIGATEUR: Chrome 120
SERVEUR: PHP 8.1

ÉTAPES:
1. [étape]
2. [étape]

RÉSULTAT: ✅ PASS / ❌ FAIL

OBSERVATIONS:
[notes supplémentaires]

CORRECTION NÉCESSAIRE: OUI/NON
Détail: [si nécessaire]
```

---

**Tester c'est valider! ✅**
