# 🔧 Guide Git - Travail en équipe

Guide des bonnes pratiques Git pour ce projet académique.

## 📌 Configuration initiale

```bash
# Configuration locale
git config user.name "Votre Nom"
git config user.email "votre.email@example.com"

# Configuration globale (optionnel)
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

## 🚀 Workflow standard (Git Flow simplifié)

### 1. Cloner le projet
```bash
git clone https://github.com/utilisateur/e-commerce-librebooks.git
cd e-commerce-librebooks
```

### 2. Créer une branche pour votre fonctionnalité
```bash
# Partir de main/master
git checkout main
git pull origin main

# Créer une branche
git checkout -b feature/ma-fonctionnalite
# Ou: git switch -c feature/ma-fonctionnalite
```

### 3. Développer et commiter

```bash
# Voir l'état
git status

# Ajouter les fichiers
git add .              # Tous les fichiers
git add src/           # Un dossier spécifique
git add file.php       # Un fichier

# Commiter (message clair!)
git commit -m "Ajouter: gestion du panier AJAX"

# Ou avec une description
git commit -m "Ajouter: gestion du panier AJAX

- Endpoint POST /src/api/add-to-cart.php
- Validation côté serveur
- Réponse JSON"
```

### 4. Récupérer les changements du serveur
```bash
# Avant de pousser
git pull origin main

# Si conflits, les résoudre puis:
git add .
git commit -m "Résoudre conflits merge"
```

### 5. Pousser vers le serveur
```bash
git push origin feature/ma-fonctionnalite
```

### 6. Créer une Pull Request
Sur GitHub/GitLab:
- Décrire la fonctionnalité
- Référencer les issues
- Attendre la revue de code
- Fusionner dans main

---

## 📝 Conventions de commits

### Format
```
<type>: <sujet>

<description (optionnel)>
```

### Types
- **feat**: Nouvelle fonctionnalité
- **fix**: Correction de bug
- **docs**: Documentation
- **style**: Formatage (pas de logique)
- **refactor**: Restructuration
- **test**: Ajout/modification tests
- **chore**: Tâches (dépendances, build)

### Exemples

```bash
# Bonne
git commit -m "feat: ajouter recherche AJAX"
git commit -m "fix: corriger bug prix panier"
git commit -m "docs: compléter README"
git commit -m "refactor: simplifier Cart::getTotal()"

# À éviter
git commit -m "modifs"
git commit -m "wip"
git commit -m "fix stuff"
```

---

## 🌳 Structure des branches

```
main (production)
  └─ release branches
  
develop (développement)
  ├─ feature/authentification
  ├─ feature/panier
  ├─ feature/admin-panel
  ├─ hotfix/sql-injection
  └─ bugfix/session-timeout
```

### Noms de branches
```
feature/nom-fonctionnalite
bugfix/description-du-bug
hotfix/urgence-production
docs/nom-documentation
refactor/description
```

---

## 👥 Collaboration en équipe

### Scénario 1: Synchroniser avec main
```bash
# Vous êtes sur votre branche
git fetch origin                    # Récupérer l'état serveur
git rebase origin/main             # Rebase sur main (linéaire)
# Ou: git merge origin/main        # Merge (avec commit)
```

### Scénario 2: Résoudre conflits
```bash
# Conflit détecté
git status                          # Voir les conflits

# Éditer les fichiers en conflit (look for <<<<<<)
# Puis:
git add .
git commit -m "Résoudre conflits"
git push origin feature/...
```

### Scénario 3: Annuler des changements
```bash
# Annuler changement d'un fichier (pas commité)
git checkout -- file.php

# Annuler le dernier commit (garder les changements)
git reset --soft HEAD~1

# Annuler le dernier commit (supprimer les changements)
git reset --hard HEAD~1

# Annuler un commit ancien
git revert abc1234  # Create new commit that undoes abc1234
```

### Scénario 4: Stasher des changements
```bash
# Sauvegarder le travail en cours (pas commité)
git stash

# Changer de branche
git checkout autre-branche

# Revenir et restaurer
git checkout ma-branche
git stash pop
```

---

## 📊 Commits à respecter

### Par tâche

```
Tâche: Implémenter authentification

Commits atomiques:
1. "feat: ajouter classe Auth"
2. "feat: créer page login.php"
3. "feat: ajouter validation formulaire"
4. "feat: implémenter sessions PHP"
5. "test: ajouter tests authentification"
```

### Par fichier/module

```
Tâche: Ajouter recherche AJAX

Commits:
1. "feat: ajouter API search.php"
2. "feat: implémenter fetch côté client"
3. "style: ajouter CSS recherche"
4. "docs: documenter API search"
```

---

## 🔍 Commandes utiles

```bash
# Voir l'historique
git log
git log --oneline              # Format court
git log --graph --all         # Graphique des branches
git log --author="Jean"        # Filtrer par auteur

# Voir les changements
git diff                       # Changements pas stagés
git diff --staged             # Changements stagés
git diff HEAD~3               # Depuis 3 commits

# Voir l'état
git status                     # État actuel
git branch                     # Liste branches
git branch -a                  # Toutes les branches

# Undo/Reset
git reset file.php            # Unstage file
git reset HEAD~2              # Annuler 2 commits
git clean -fd                 # Supprimer fichiers non trackés

# Tag (versions)
git tag v1.0.0
git push origin v1.0.0
```

---

## 🎯 Exemple complet: Ajouter une fonctionnalité

```bash
# 1. Se mettre à jour
git checkout main
git pull origin main

# 2. Créer la branche
git checkout -b feature/notification-email

# 3. Développer
# ... éditer les fichiers ...

# 4. Vérifier les changements
git status
git diff

# 5. Commiter progressivement
git add src/classes/Email.php
git commit -m "feat: créer classe Email"

git add src/api/send-notification.php
git commit -m "feat: ajouter API notification"

git add public/pages/user-settings.php
git commit -m "feat: ajouter paramètres email utilisateur"

# 6. Avant de pousser, se synchroniser
git fetch origin
git rebase origin/main

# 7. Pousser
git push -u origin feature/notification-email

# 8. Sur GitHub: créer Pull Request
# Attendre review et merge
```

---

## 🚫 À ÉVITER absolument

```bash
# ❌ Ne pas commiter les credentials
git add src/config/Database.php    # NE PAS FAIRE!

# ❌ Ne pas faire de commits trop gros
# Diviser en commits logiques

# ❌ Ne pas forcer les pushes sur main
git push -f origin main            # DANGEREUX!

# ❌ Ne pas commiter des dépendances
git add vendor/
git add node_modules/              # Utiliser .gitignore

# ❌ Ne pas ignorer les conflits
# Les résoudre correctement!
```

---

## 📋 Checklist avant de pousser

- [ ] Code testé localement
- [ ] Pas de credentials commitées
- [ ] Messages de commits clairs
- [ ] Branche à jour avec main
- [ ] Pas de fichiers oubliés
- [ ] Pas de fichiers à ignorer

---

## 🔄 Code Review

### Pour le reviewer
```bash
# Voir les changements
git diff main...feature/xyz

# Tester la branche
git checkout feature/xyz
# Tester...
git checkout main
```

### Checklist de review
- [ ] Code lisible et commenté
- [ ] Pas de SQL injection
- [ ] Gestion des erreurs
- [ ] Tests (si ajoutés)
- [ ] Documentation

---

## 📚 Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Flow Guide](https://guides.github.com/introduction/flow/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Tips & Tricks](https://git-tips.readthedocs.io/)

---

**Bonnes pratiques Git = projet organisé! 🎯**
