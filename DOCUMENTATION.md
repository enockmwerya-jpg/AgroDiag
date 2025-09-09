# 📋 Documentation du Projet AgroDiag

## Introduction
**AgroDiag** est une application Progressive Web App (PWA) dédiée à l'analyse phytosanitaire intelligente. Elle utilise des technologies modernes pour permettre aux ingénieurs agronomes de diagnostiquer les maladies des plantes via la capture d'images.

## Fonctionnalités Principales
- 📸 **Capture d'image** : Utilisation de l'appareil photo pour capturer des images de plantes.
- 🤖 **Analyse IA** : Exploitation de modèles CNN entraînés pour diagnostiquer instantanément des maladies à partir de photos.
- 📂 **Base de données enrichissable** : Stockage et mise à jour automatique des diagnostics.
- 🌐 **Interface Multilingue** : Supporte plusieurs langues et fonctionne hors-ligne.
- 🔒 **Sécurité API** : Utilisation de JWT pour sécuriser l'API REST.
- 📈 **Historique des diagnostics** : Visualiser les diagnostics précédents.

## Architecture Technique

### Backend
- **Framework**: Django + Django REST Framework (DRF) pour construire l'API REST.
- **Base de données**: MySQL pour stocker les données de diagnostic et des utilisateurs.
- **Authentification**: JSON Web Tokens (JWT) pour sécuriser les endpoints API.
- **Intelligence Artificielle**: Utilisation de PyTorch et TensorFlow pour l'analyse d'images avec OpenCV.

### Frontend
- **Framework**: ReactJS pour créer une application riche et interactive.
- **PWA**: Utilisation de PWABuilder pour améliorer l'application et la rendre installable sur mobile.
- **UI**: Material-UI pour une interface utilisateur élégante et moderne.

### Structure du Projet

```
AgroDiag/
├── backend/          # API Django REST
├── frontend/         # Application React PWA
├── ai_models/        # Modèles IA et scripts d'entraînement
├── database/         # Scripts et migrations DB
├── docs/             # Documentation
└── docker-compose.yml
```

## Installation

### Prérequis
- **Python 3.9+**
- **Node.js 16+**
- **MySQL 8.0+**
- **Docker** (Optionnel)

### Configuration Rapide
1. **Clonez le dépôt** avec `git clone`.
2. **Backend Django** :
   - Créez un environnement virtuel.
   - Installez les dépendances Python listées dans `requirements.txt`.
   - Configurez la base de données MySQL.
   - Appliquez les migrations.
3. **Frontend React** :
   - Installez les dépendances Node.js.
   - Démarrez le serveur de développement.

4. **Modèles IA** :
   - Déployez ou entraîne les modèles requis à partir du dataset PlantVillage.

### Utilisation avec Docker
- Exécutez `docker-compose up --build` pour lancer tous les services en même temps.
- Accédez à l'application via `http://localhost:3000` (Frontend) et `http://localhost:8000` (Backend).

## Technologies et Outils Utilisés

### Backend
- **Django/Django REST Framework**: Architecture rapide et sécurisée pour développer des APIs REST.
- **MySQL**: Système de gestion de bases de données relationnelles.
- **PyTorch/TensorFlow**: Plateformes d'apprentissage profond pour entraîner et exécuter des modèles d'IA.
- **Celery & Redis**: Gestion des tâches asynchrones pour le traitement intensif des données.

### Frontend
- **ReactJS**: Bibliothèque JavaScript pour construire une interface utilisateur composée de composants réutilisables.
- **Material-UI**: Garantit une interface utilisateur cohérente et professionnelle.
- **i18next**: Framework de gestion des langues pour les applications JavaScript.

### CI/CD et Déploiement
- **Docker**: Conteneurisation pour assurer la cohérence des environnements de développement et de production.
- **Git**: Contrôle de version pour suivre les modifications du code source et collaborer facilement.

## Contributions et Support

1. **Forker le dépôt GitHub** et créez une nouvelle branche pour vos modifications.
2. **Envoyer une Pull Request** avec une description détaillée des changements.
3. **Rapport d'issues** : En cas de bugs, les signaler via les issues GitHub.

Pour toute question ou assistance, contactez-nous par email à [support@agrodiag.com](mailto:support@agrodiag.com).
