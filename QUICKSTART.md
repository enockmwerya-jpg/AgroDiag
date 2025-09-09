# 🚀 Guide de Démarrage Rapide - AgroDiag

Ce guide vous permettra de lancer rapidement l'application AgroDiag en développement.

## 📋 Prérequis

Assurez-vous d'avoir installé :
- **Python 3.9+** 
- **Node.js 16+**
- **MySQL 8.0+**
- **Redis** (optionnel, pour Celery)
- **Git**

## ⚡ Démarrage Rapide avec Docker

### 1. Cloner le repository
```bash
git clone <repository-url>
cd AgroDiag
```

### 2. Lancer avec Docker Compose
```bash
# Construire et lancer tous les services
docker-compose up --build

# En arrière-plan
docker-compose up -d --build
```

### 3. Accéder à l'application
- **Frontend PWA**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Documentation API**: http://localhost:8000/api/schema/swagger-ui/
- **Admin Django**: http://localhost:8000/admin

## 🛠️ Développement Local (Sans Docker)

### Backend Django

```bash
# 1. Aller dans le dossier backend
cd backend

# 2. Créer un environnement virtuel
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Linux/Mac

# 3. Installer les dépendances
pip install -r requirements.txt

# 4. Configurer l'environnement
cp .env.example .env
# Éditer le fichier .env avec vos paramètres

# 5. Configurer MySQL
mysql -u root -p
CREATE DATABASE agrodiag_db CHARACTER SET utf8mb4;
EXIT;

# 6. Migrations
python manage.py makemigrations
python manage.py migrate

# 7. Créer un superutilisateur
python manage.py createsuperuser

# 8. Lancer le serveur
python manage.py runserver
```

### Frontend React PWA

```bash
# Dans un nouveau terminal
cd frontend

# Installer les dépendances
npm install

# Lancer le serveur de développement
npm start
```

### Services additionnels (Optionnels)

```bash
# Redis (pour Celery)
redis-server

# Celery Worker (dans le dossier backend)
celery -A agrodiag_backend worker -l info

# Celery Beat (tâches périodiques)
celery -A agrodiag_backend beat -l info
```

## 🔧 Configuration Initiale

### 1. Créer des données de test

```bash
# Dans le backend
python manage.py shell

# Créer des catégories et plantes de base
from plants.models import PlantCategory, Plant
from diseases.models import DiseaseCategory, Disease

# Catégories de plantes
vegetables = PlantCategory.objects.create(name="Légumes", description="Légumes cultivés")
fruits = PlantCategory.objects.create(name="Fruits", description="Arbres fruitiers")

# Exemple de plante
tomato = Plant.objects.create(
    scientific_name="Solanum lycopersicum",
    common_name="Tomate",
    common_name_fr="Tomate",
    category=vegetables,
    family="Solanaceae"
)

print("Données de test créées !")
```

### 2. Tester l'API

```bash
# Test de l'API plants
curl http://localhost:8000/api/v1/plants/categories/

# Test de l'API avec authentification (après création d'un token)
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8000/api/v1/plants/plants/
```

## 📱 Fonctionnalités Principales

### Backend (Django REST API)
- ✅ Modèles complets (Plants, Diseases, Treatments, Diagnostics)
- ✅ API REST avec authentification JWT
- ✅ Interface d'administration Django
- ✅ Support multilingue (FR, EN, AR)
- ✅ Configuration Docker
- 🔄 Service IA (à développer)
- 🔄 Endpoints de diagnostic (à compléter)

### Frontend (React PWA)
- 📦 Structure de base configurée
- 📦 PWA ready avec Service Workers
- 📦 Material-UI pour l'interface
- 📦 Support multilingue avec i18next
- 🔄 Composants à développer
- 🔄 Intégration camera/upload d'images
- 🔄 Fonctionnalités offline

### IA et Vision
- 📦 Modèles PyTorch/TensorFlow supportés
- 📦 Traitement d'images avec OpenCV
- 🔄 Modèles entraînés sur PlantVillage
- 🔄 Pipeline de diagnostic automatisé

## 🐛 Résolution de Problèmes

### Erreurs communes

1. **Erreur de connexion MySQL**
   ```bash
   # Vérifier que MySQL est démarré
   mysqladmin -u root -p status
   
   # Vérifier les paramètres dans .env
   DB_HOST=localhost
   DB_PORT=3306
   ```

2. **Erreur de migrations Django**
   ```bash
   # Supprimer les migrations si nécessaire
   find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
   find . -path "*/migrations/*.pyc" -delete
   
   # Recréer les migrations
   python manage.py makemigrations
   python manage.py migrate
   ```

3. **Problème de dépendances Python**
   ```bash
   # Réinstaller les dépendances
   pip install --upgrade -r requirements.txt
   
   # En cas de conflit avec OpenCV
   pip uninstall opencv-python opencv-contrib-python
   pip install opencv-python==4.8.1.78
   ```

4. **Frontend ne démarre pas**
   ```bash
   # Nettoyer le cache npm
   npm cache clean --force
   rm -rf node_modules package-lock.json
   npm install
   ```

## 📝 Prochaines Étapes

1. **Développement du service IA**
   - Intégrer les modèles CNN pour la classification
   - Implémenter la détection de maladies
   - Créer l'API de diagnostic

2. **Complétion du frontend**
   - Interface de capture/upload d'images
   - Écrans de diagnostic et résultats
   - Historique et profil utilisateur

3. **Fonctionnalités avancées**
   - Géolocalisation et conditions météo
   - Recommandations personnalisées
   - Export des diagnostics

## 🤝 Contribution

Pour contribuer au projet :
1. Fork le repository
2. Créer une branche feature
3. Développer et tester
4. Soumettre une Pull Request

## 📞 Support

- 📧 Email : support@agrodiag.com
- 📱 Issues GitHub : Créer une issue pour les bugs
- 📚 Documentation : Voir les README dans chaque dossier

---
**AgroDiag** - Diagnostic phytosanitaire intelligent 🌱🔬
