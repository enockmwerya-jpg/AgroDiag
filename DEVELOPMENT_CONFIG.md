# Configuration de Développement - AgroDiag

## 🚀 Lancement Rapide

1. **Lancer les serveurs** : `start_servers.bat`
2. **Ouvrir le navigateur** : http://localhost:3000 (automatique)
3. **Tester la configuration** : `node frontend/check-proxy.js`

## 🔧 Configuration du Proxy

### Vite (Frontend)
- **Port** : 3000
- **Proxy** : `/api/*` → `http://localhost:8000/api/*`
- **Fichier** : `frontend/vite.config.mjs`

### Django (Backend)
- **Port** : 8000
- **API** : `/api/v1/*`
- **Admin** : `/admin/`

## 🌐 URLs de Développement

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:3000 | Application React principale |
| **Backend** | http://localhost:8000 | Serveur Django |
| **API** | http://localhost:3000/api/* | Proxy vers Django |
| **Admin** | http://localhost:8000/admin/ | Interface d'administration |

## 🔐 Détection des Utilisateurs Admin

### Champs Django
- `user.is_staff` : Utilisateur staff
- `user.is_superuser` : Super utilisateur

### Affichage Frontend
- **Bouton Admin** : Visible uniquement pour les admins
- **Localisation** : 
  - Menu utilisateur (Header)
  - Menu mobile (Header)
  - Page d'accueil (HomePage)

## 🧪 Composants de Debug

### UserDebugInfo
- **Visible** : En développement uniquement
- **Affichage** : Informations utilisateur + statut admin
- **Localisation** : Page d'accueil

### AdminButton
- **Visible** : Pour les utilisateurs admin uniquement
- **Action** : Ouvre `/admin/` dans un nouvel onglet
- **Styles** : Bouton Material-UI avec icône

## 📁 Structure des Fichiers

```
frontend/
├── vite.config.mjs          # Configuration proxy
├── check-proxy.js           # Script de test
├── src/
│   ├── components/common/
│   │   ├── Header.js        # Bouton admin dans le menu
│   │   ├── AdminButton.js   # Composant bouton admin
│   │   └── UserDebugInfo.js # Info debug (dev uniquement)
│   └── pages/
│       └── HomePage.js      # Bouton admin sur la page d'accueil
```

## 🐛 Dépannage

### Le proxy ne fonctionne pas
1. Vérifiez que Django tourne sur le port 8000
2. Vérifiez que React tourne sur le port 3000
3. Exécutez `node frontend/check-proxy.js`
4. Redémarrez les deux serveurs

### Le bouton admin ne s'affiche pas
1. Vérifiez que l'utilisateur est connecté
2. Vérifiez que `user.is_staff` ou `user.is_superuser` est `true`
3. Regardez les composants de debug sur la page d'accueil
4. Vérifiez les logs du navigateur

### Erreurs CORS
1. Le proxy devrait résoudre les problèmes CORS
2. Vérifiez que les appels API commencent par `/api`
3. Vérifiez la configuration dans `vite.config.mjs`

## 🔄 Workflow de Développement

1. **Modifier le backend** : Les changements sont visibles sur http://localhost:8000
2. **Modifier le frontend** : Hot reload automatique sur http://localhost:3000
3. **Tester l'API** : Les appels `/api/*` passent automatiquement par le proxy
4. **Accéder à l'admin** : Via le bouton admin ou directement sur http://localhost:8000/admin/

## 📱 Avantages de cette Configuration

✅ **Développement unifié** : Un seul navigateur ouvert sur le frontend
✅ **Pas de CORS** : Le proxy résout les problèmes de cross-origin
✅ **Hot reload** : Vite gère le frontend, Django gère le backend
✅ **Admin intégré** : Accès direct à l'admin Django depuis le frontend
✅ **Production ready** : Configuration facilement adaptable
