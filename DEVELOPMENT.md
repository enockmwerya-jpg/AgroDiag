# Guide de Développement AgroDiag

## Aperçu du Projet

AgroDiag est une application de diagnostic phytosanitaire intelligent composée de :

- **Backend** : API Django avec Django REST Framework
- **Frontend** : Application web avec Vite.js et TailwindCSS
- **Base de données** : SQLite (développement) / MySQL (production)
- **Cache/Queue** : Redis avec Celery

## Configuration Rapide

### Prérequis

- Python 3.8+
- Node.js 16+
- Git

### Installation Automatique

Exécutez le script de configuration :

```bash
# Windows (Batch)
setup_dev_environment.bat

# Windows (PowerShell - Recommandé)
.\setup_dev_environment.ps1
```

## Scripts de Développement

### Scripts PowerShell (Recommandés)

#### Démarrer les serveurs
```powershell
# Démarrer tous les serveurs
.\start_dev_servers.ps1

# Démarrer uniquement le backend
.\start_dev_servers.ps1 -SkipFrontend

# Démarrer uniquement le frontend
.\start_dev_servers.ps1 -SkipBackend

# Mode verbose
.\start_dev_servers.ps1 -Verbose
```

#### Arrêter les serveurs
```powershell
.\stop_dev_servers.ps1
```

### Scripts Batch (Compatibilité)

```batch
# Démarrer les serveurs
start_dev_servers.bat

# Arrêter les serveurs  
stop_dev_servers.bat
```

## Configuration Frontend (Vite)

### Variables d'environnement

Le frontend utilise les variables d'environnement suivantes (définies dans `.env`):

```env
# API Backend
VITE_API_URL=http://localhost:8000/api/v1

# Configuration de l'application
VITE_APP_NAME=AgroDiag
VITE_APP_VERSION=1.0.0

# Upload des fichiers
VITE_MAX_FILE_SIZE=5242880  # 5MB
VITE_ALLOWED_FILE_TYPES=image/jpeg,image/jpg,image/png,image/gif

# PWA
VITE_PWA_NAME=AgroDiag
VITE_PWA_DESCRIPTION=Application de diagnostic phytosanitaire intelligent

# Fonctionnalités
VITE_ENABLE_NOTIFICATIONS=true
VITE_ENABLE_GEOLOCATION=true

# Internationalisation
VITE_DEFAULT_LANGUAGE=fr
VITE_SUPPORTED_LANGUAGES=fr,en,ar
```

### Scripts NPM

```bash
# Développement
npm start          # Démarrer le serveur de développement
npm run dev        # Alias pour npm start

# Production
npm run build      # Construire pour la production
npm run preview    # Prévisualiser le build de production

# Qualité du code
npm run lint       # Vérifier le code
npm run lint:fix   # Corriger automatiquement
npm run format     # Formater le code
```

### Technologies Frontend

- **Vite** : Build tool et serveur de développement
- **TailwindCSS** : Framework CSS utilitaire
- **Vanilla JavaScript** : Pas de framework lourd
- **PWA** : Support des Progressive Web Apps
- **Workbox** : Service Workers pour le cache offline

## Configuration Backend (Django)

### Structure

```
backend/
├── agrodiag_backend/     # Configuration principale
├── authentication/      # Authentification utilisateurs
├── plants/              # Modèles de plantes
├── diseases/            # Modèles de maladies
├── diagnostics/         # Logique de diagnostic
├── treatments/          # Traitements recommandés
├── ai_service/          # Service d'IA
└── requirements.txt     # Dépendances Python
```

### Commandes Django

```bash
# Activer l'environnement virtuel
backend\venv\Scripts\activate

# Migrations
python manage.py makemigrations
python manage.py migrate

# Créer un superutilisateur
python manage.py createsuperuser

# Collecter les fichiers statiques
python manage.py collectstatic

# Démarrer le serveur
python manage.py runserver 8000
```

## URLs de Développement

Une fois les serveurs démarrés :

- **Frontend** : http://localhost:3000
- **Backend API** : http://localhost:8000/api/v1
- **Admin Django** : http://localhost:8000/admin
- **Documentation API** : http://localhost:8000/api/schema/swagger-ui/

## Déploiement avec Docker

### Développement
```bash
# Démarrer tous les services
docker-compose up --build

# Démarrer en arrière-plan
docker-compose up -d
```

### Production
```bash
# Utiliser le script de déploiement
./deploy.sh production
```

## Structure des Fichiers

```
AgroDiag/
├── backend/                    # API Django
│   ├── agrodiag_backend/      # Configuration
│   ├── apps/                  # Applications Django
│   └── requirements.txt
├── frontend/                  # Application Vite
│   ├── src/                   # Code source
│   │   ├── index.html        # Page principale
│   │   ├── main.js           # JavaScript principal
│   │   └── index.css         # Styles TailwindCSS
│   ├── public/               # Fichiers statiques
│   ├── package.json          # Dépendances npm
│   └── vite.config.js        # Configuration Vite
├── docker-compose.yml        # Configuration Docker
├── start_dev_servers.ps1     # Script PowerShell de démarrage
├── stop_dev_servers.ps1      # Script PowerShell d'arrêt
└── README.md                 # Documentation
```

## Dépannage

### Problèmes Courants

1. **Port déjà utilisé**
   ```powershell
   # Arrêter tous les serveurs
   .\stop_dev_servers.ps1
   ```

2. **Environnement virtuel manquant**
   ```bash
   cd backend
   python -m venv venv
   ```

3. **Dépendances manquantes**
   ```bash
   # Backend
   pip install -r requirements.txt
   
   # Frontend
   npm install
   ```

4. **Variables d'environnement**
   ```bash
   # Copier le fichier d'exemple
   cp frontend/.env.example frontend/.env
   ```

### Logs et Debug

- **Backend** : Les logs Django s'affichent dans la console
- **Frontend** : Ouvrir les DevTools du navigateur (F12)
- **Docker** : `docker-compose logs -f`

## Contribution

1. Créer une branche feature
2. Développer la fonctionnalité
3. Tester avec les scripts de développement
4. Soumettre une Pull Request

## Support

Pour toute question ou problème :
1. Vérifier la documentation
2. Consulter les logs d'erreur
3. Utiliser les scripts de dépannage fournis
