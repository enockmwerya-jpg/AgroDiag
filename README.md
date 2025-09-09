# AgroDiag - Application de Diagnostic Phytosanitaire Intelligent

## Description
AgroDiag est une application PWA (Progressive Web App) destinée aux ingénieurs agronomes pour le diagnostic phytosanitaire intelligent. L'application utilise l'intelligence artificielle pour analyser des photos de plantes et diagnostiquer instantanément les maladies.

## Fonctionnalités principales
- 📷 Capture d'image via l'appareil photo
- 🧠 Analyse IA avec modèles CNN (basés sur PlantVillage dataset)
- 💾 Base de données locale enrichissable automatiquement
- 💊 Recommandations de traitement (naturel et chimique)
- 🌐 Interface PWA multilingue et hors-ligne
- 🔐 API REST sécurisée avec JWT
- 📊 Historique des diagnostics
- 🔄 Mise à jour automatique de la base via IA

## Architecture technique

### Backend
- **Framework**: Django + Django REST Framework
- **Base de données**: MySQL
- **Authentification**: JWT
- **IA**: PyTorch/TensorFlow + OpenCV

### Frontend
- **Framework**: ReactJS
- **PWA**: PWABuilder
- **Fonctionnalités**: Offline-first, multilingue

### Structure du projet
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
- Python 3.9+
- Node.js 16+
- MySQL 8.0+
- Docker (optionnel)

### Configuration
1. Cloner le repository
2. Configurer le backend Django
3. Installer les dépendances Python et Node.js
4. Configurer la base de données MySQL
5. Entraîner/déployer les modèles IA

## Développement
Voir les README spécifiques dans chaque dossier :
- [Backend README](./backend/README.md)
- [Frontend README](./frontend/README.md)
- [AI Models README](./ai_models/README.md)

## Licence
MIT License
