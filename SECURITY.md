# 🔒 Sécurité - Bonnes pratiques

Document détaillant les mesures de sécurité implémentées et celles à améliorer.

## ✅ Sécurité implémentée

### 1. Prévention SQL Injection

**Implémentation**: Prepared Statements avec PDO

```php
// ✅ BON - Prepared statement
$stmt = $pdo->prepare("SELECT * FROM users WHERE username = ?");
$stmt->execute([$username]);

// ✅ BON - Paramètres nommés
$stmt = $pdo->prepare("SELECT * FROM books WHERE category_id = :cat");
$stmt->execute([':cat' => $category_id]);

// ❌ MAUVAIS - Concaténation (NE PAS FAIRE!)
$query = "SELECT * FROM users WHERE username = '$username'";
```

**Fichiers concernés**:
- `src/config/Database.php` - Utilise PDO
- `src/classes/Book.php` - Méthode `search()`
- `src/classes/Cart.php` - Requêtes préparées
- `src/api/*.php` - Validation des paramètres

### 2. Authentification sécurisée

**Implémentation**: Bcrypt pour le hash des mots de passe

```php
// ✅ BON - Hachage bcrypt
$password_hash = password_hash($password, PASSWORD_DEFAULT);

// ✅ BON - Vérification
if (password_verify($password, $user['password_hash'])) {
    // Authentification réussie
}

// ❌ MAUVAIS - MD5 (NE PAS FAIRE!)
$hash = md5($password);  // Compromis et rapide à casser

// ❌ MAUVAIS - Plain text
$password_stored = $password;  // TRÈS DANGEREUX!
```

**Fichier**: `src/classes/Auth.php`

```php
// Inscription
$password_hash = password_hash($password, PASSWORD_DEFAULT);

// Connexion
if (!password_verify($password, $user['password_hash'])) {
    return ['success' => false, 'message' => 'Mot de passe incorrect'];
}
```

### 3. Gestion des sessions

**Implémentation**: Sessions PHP sécurisées

```php
// ✅ Démarrer la session
session_start();

// ✅ Vérifier si connecté
if (!$auth->isLoggedIn()) {
    header('Location: /pages/login.php');
    exit;
}

// ✅ Données de session
$_SESSION['user_id'] = $user['id'];
$_SESSION['username'] = $user['username'];
$_SESSION['role'] = $user['role'];

// ✅ Déconnexion complète
session_destroy();
```

**Fichiers**: 
- `src/classes/Auth.php`
- Toutes les pages protégées

### 4. Contrôle d'accès (Autorisation)

**Implémentation**: Vérification du rôle côté serveur

```php
// ✅ Vérifier si admin (côté serveur!)
if (!$auth->isAdmin()) {
    header('Location: /index.php');
    exit;
}

// ✅ Pages admin protégées
// public/pages/admin/dashboard.php
// public/pages/admin/add-book.php
// public/pages/admin/manage-books.php
```

**Fichiers**:
- `src/api/delete-book.php` - Vérification admin
- `src/api/update-user-role.php` - Vérification admin
- Toutes les pages admin

### 5. Validation des entrées

**Implémentation**: Validation côté client ET serveur

```php
// ✅ Validation serveur obligatoire
if (strlen($username) < 3) {
    return ['success' => false, 'message' => 'Nom trop court'];
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    return ['success' => false, 'message' => 'Email invalide'];
}

// ✅ Échappement pour l'affichage HTML
echo htmlspecialchars($user_input);

// ❌ MAUVAIS - Faire confiance au client
if ($_POST['role'] === 'admin') {
    // DANGER! L'utilisateur peut changer le POST
}
```

**Fichiers**:
- `src/classes/Auth.php` - Validation inscription/login
- `src/classes/Book.php` - Validation données
- Toutes les pages avec formulaires

### 6. Sécurité des en-têtes HTTP

**Implémentation**: Content-Type appropriés

```php
// ✅ API JSON
header('Content-Type: application/json');
echo json_encode($data);

// ✅ Page HTML
header('Content-Type: text/html; charset=utf-8');

// À ajouter: Content-Security-Policy
header("Content-Security-Policy: default-src 'self'");
```

---

## ⚠️ Sécurité à améliorer

### 1. Protection CSRF (Cross-Site Request Forgery)

**Situation actuelle**: ❌ NON implémenté

**Implémentation nécessaire**:

```php
// Générer un token
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

// Dans le formulaire
<input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">

// Validation
if (!hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'] ?? '')) {
    die('Requête invalide');
}
```

**Fichiers à modifier**:
- Tous les formulaires
- Toutes les requêtes AJAX sensibles

### 2. Rate Limiting

**Situation actuelle**: ❌ NON implémenté

**Risque**: Brute force (forcer les mots de passe)

**Solution**:
```php
// Limiter les tentatives de connexion
$ip = $_SERVER['REMOTE_ADDR'];
// Vérifier nombre de tentatives par IP et par heure
// Rejeter si trop de tentatives
```

### 3. HTTPS / SSL/TLS

**Situation actuelle**: ❌ Développement local

**Pour la production**:
```php
// Forcer HTTPS
if (empty($_SERVER['HTTPS'])) {
    header('Location: https://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI']);
    exit;
}

// Strict Transport Security
header("Strict-Transport-Security: max-age=31536000; includeSubDomains");
```

### 4. Content Security Policy (CSP)

**Situation actuelle**: ❌ NON implémenté

```php
header("Content-Security-Policy: default-src 'self'; script-src 'self'");
```

### 5. Logging et monitoring

**Situation actuelle**: ❌ Minimal

**À ajouter**:
```php
// Logger les tentatives de connexion échouées
error_log("Tentative de connexion échouée: $username");

// Logger les actions admin
error_log("Admin $admin_id a supprimé le livre $book_id");

// Logging de sécurité
error_log("Tentative d'accès non autorisé: $user_id");
```

### 6. Contrôle des uploads

**Situation actuelle**: ⚠️ URLs seulement (pas de uploads)

**Quand implémenter les uploads**:
```php
// Valider le type MIME
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $_FILES['file']['tmp_name']);
if (!in_array($mime, ['image/jpeg', 'image/png'])) {
    die('Type de fichier invalide');
}

// Renommer le fichier
$new_name = bin2hex(random_bytes(16)) . '.jpg';

// Stocker en dehors de la racine web
move_uploaded_file($_FILES['file']['tmp_name'], '/var/uploads/' . $new_name);
```

### 7. Variables d'environnement

**Situation actuelle**: ⚠️ Hardcodé dans le code

**À améliorer**:
```php
// Utiliser .env
require_once 'vendor/autoload.php';
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

// Accéder aux variables
$db_host = $_ENV['DB_HOST'];
$db_user = $_ENV['DB_USER'];
```

**.env.example**:
```
DB_HOST=localhost
DB_NAME=ecom_bookstore
DB_USER=root
DB_PASSWORD=
```

**.gitignore**:
```
.env        # NE PAS commiter!
.env.local
```

---

## 🛡️ Checklist de sécurité

### Avant la mise en production

- [ ] HTTPS/SSL/TLS activé
- [ ] Credentials dans variables d'environnement
- [ ] CSRF tokens implémentés
- [ ] Rate limiting en place
- [ ] Logging des événements importants
- [ ] Headers de sécurité configurés
- [ ] Mots de passe admin forts
- [ ] Sauvegardes régulières
- [ ] Monitoring et alertes
- [ ] Dépendances à jour
- [ ] Tests de sécurité (OWASP)
- [ ] SQL injection testée (impossible)
- [ ] XSS testée (impossible)
- [ ] Accessibilité des pages admin vérifiée

---

## 🔍 Test de sécurité basique

### 1. Tester SQL Injection

```
Champ username: ' OR '1'='1
Résultat: ❌ Devrait être rejeté
```

**Vérification**: Utiliser prepared statements ✅

### 2. Tester XSS

```
Champ description: <script>alert('XSS')</script>
Résultat: ❌ Devrait afficher du texte, pas exécuter le script
```

**Vérification**: Utiliser htmlspecialchars() ✅

### 3. Tester accès non autorisé

```
Accéder à /pages/admin/dashboard.php sans être admin
Résultat: ❌ Devrait être redirigé vers /index.php
```

**Vérification**: Vérification du rôle ✅

### 4. Tester modification de session

```
Modifier le cookie de session
Résultat: ❌ Session invalidée
```

**Vérification**: PHP gère les sessions sécurisées

---

## 📚 Resources de sécurité

### OWASP Top 10
1. [OWASP Top 10 - 2021](https://owasp.org/Top10/)
2. [OWASP PHP Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/PHP_Configuration_Cheat_Sheet.html)

### PHP Security
- [PHP Security Manual](https://www.php.net/manual/en/security.php)
- [Secure Coding Standards](https://www.php.net/manual/en/security.filesystem.php)

### Testing
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Burp Suite](https://portswigger.net/burp) - Outil de test

---

## 🚨 Incident Response

Si compromission détectée:

1. **Isoler le système**
   ```bash
   # Arrêter le serveur
   sudo service apache2 stop
   ```

2. **Sauvegarder les logs**
   ```bash
   cp /var/log/apache2/access.log backup-$(date +%s).log
   ```

3. **Analyser la brèche**
   - Vérifier les logs
   - Identifier le vecteur d'attaque
   - Évaluer les dégâts

4. **Nettoyer et patcher**
   - Appliquer les correctifs de sécurité
   - Réinitialiser les mots de passe
   - Vérifier les accès

5. **Restaurer**
   - Depuis une sauvegarde sécurisée
   - Vérifier l'intégrité des données

6. **Communiquer**
   - Informer les utilisateurs si nécessaire
   - Documenter l'incident

---

**La sécurité est un processus continu! 🔐**
