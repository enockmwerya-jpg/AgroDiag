#!/bin/bash

# Script de déploiement automatisé pour AgroDiag
# Usage: ./deploy.sh [development|production]

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage coloré
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Variables
ENVIRONMENT=${1:-development}
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$PROJECT_DIR/backend"
FRONTEND_DIR="$PROJECT_DIR/frontend"

log_info "🚀 Démarrage du déploiement AgroDiag en mode: $ENVIRONMENT"

# Vérification des prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    # Vérifier Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker n'est pas installé"
        exit 1
    fi
    
    # Vérifier Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose n'est pas installé"
        exit 1
    fi
    
    # Vérifier les fichiers de configuration
    if [ ! -f "$BACKEND_DIR/.env" ]; then
        log_warning "Fichier .env manquant dans le backend"
        if [ -f "$BACKEND_DIR/.env.example" ]; then
            log_info "Copie du fichier .env.example vers .env"
            cp "$BACKEND_DIR/.env.example" "$BACKEND_DIR/.env"
            log_warning "⚠️  Veuillez éditer le fichier .env avec vos paramètres"
        fi
    fi
    
    log_success "Prérequis vérifiés"
}

# Configuration pour le développement
setup_development() {
    log_info "Configuration pour l'environnement de développement..."
    
    # Variables d'environnement pour le développement
    export DEBUG=True
    export DJANGO_SETTINGS_MODULE=agrodiag_backend.settings
    
    # Arrêter les conteneurs existants
    log_info "Arrêt des conteneurs existants..."
    docker-compose down
    
    # Construire et lancer les services
    log_info "Construction et lancement des services..."
    docker-compose up --build -d
    
    # Attendre que la base de données soit prête
    log_info "Attente de la base de données..."
    sleep 10
    
    # Exécuter les migrations
    log_info "Exécution des migrations..."
    docker-compose exec backend python manage.py migrate
    
    # Créer un superutilisateur si nécessaire
    log_info "Création du superutilisateur (si nécessaire)..."
    docker-compose exec backend python manage.py shell -c "
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@agrodiag.com', 'admin123')
    print('Superutilisateur créé: admin/admin123')
else:
    print('Superutilisateur déjà existant')
"
    
    # Charger des données de test
    log_info "Chargement des données de test..."
    docker-compose exec backend python manage.py shell -c "
from plants.models import PlantCategory, Plant
from diseases.models import DiseaseCategory, Disease

# Créer des catégories de base si elles n'existent pas
if not PlantCategory.objects.exists():
    vegetables = PlantCategory.objects.create(name='Légumes', description='Légumes cultivés')
    fruits = PlantCategory.objects.create(name='Fruits', description='Arbres fruitiers')
    cereals = PlantCategory.objects.create(name='Céréales', description='Céréales et graminées')
    print('Catégories de plantes créées')

if not DiseaseCategory.objects.exists():
    fungal = DiseaseCategory.objects.create(name='Fongique', description='Maladies fongiques')
    bacterial = DiseaseCategory.objects.create(name='Bactérienne', description='Maladies bactériennes')
    viral = DiseaseCategory.objects.create(name='Virale', description='Maladies virales')
    print('Catégories de maladies créées')

print('Données de test chargées')
"
    
    log_success "Environnement de développement configuré"
    log_info "🌐 Application disponible sur:"
    log_info "   - Frontend: http://localhost:3000"
    log_info "   - Backend API: http://localhost:8000"
    log_info "   - Admin Django: http://localhost:8000/admin (admin/admin123)"
    log_info "   - Documentation API: http://localhost:8000/api/schema/swagger-ui/"
}

# Configuration pour la production
setup_production() {
    log_info "Configuration pour l'environnement de production..."
    
    # Variables d'environnement pour la production
    export DEBUG=False
    export DJANGO_SETTINGS_MODULE=agrodiag_backend.settings.production
    
    # Vérifier les variables d'environnement critiques
    if [ -z "$SECRET_KEY" ]; then
        log_error "SECRET_KEY non définie pour la production"
        exit 1
    fi
    
    # Construire les images pour la production
    log_info "Construction des images de production..."
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
    
    # Lancer les services
    log_info "Lancement des services de production..."
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
    
    # Migrations et collecte des fichiers statiques
    log_info "Migrations et collecte des fichiers statiques..."
    docker-compose exec backend python manage.py migrate
    docker-compose exec backend python manage.py collectstatic --noinput
    
    log_success "Environnement de production configuré"
}

# Nettoyage
cleanup() {
    log_info "Nettoyage des ressources non utilisées..."
    docker system prune -f
    docker volume prune -f
    log_success "Nettoyage terminé"
}

# Sauvegarde de la base de données
backup_database() {
    log_info "Sauvegarde de la base de données..."
    BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).sql"
    docker-compose exec db mysqldump -u root -p$MYSQL_ROOT_PASSWORD agrodiag_db > "$BACKUP_FILE"
    log_success "Base de données sauvegardée dans $BACKUP_FILE"
}

# Affichage des logs
show_logs() {
    log_info "Affichage des logs..."
    docker-compose logs -f
}

# Fonction principale
main() {
    cd "$PROJECT_DIR"
    
    case "$ENVIRONMENT" in
        "development")
            check_prerequisites
            setup_development
            ;;
        "production")
            check_prerequisites
            setup_production
            ;;
        "backup")
            backup_database
            ;;
        "logs")
            show_logs
            ;;
        "cleanup")
            cleanup
            ;;
        *)
            log_error "Environnement non reconnu: $ENVIRONMENT"
            log_info "Usage: $0 [development|production|backup|logs|cleanup]"
            exit 1
            ;;
    esac
}

# Gestion des signaux pour un arrêt propre
trap 'log_warning "Arrêt du script..."; exit 0' SIGINT SIGTERM

# Exécution du script principal
main "$@"

log_success "✅ Déploiement terminé avec succès!"
