# Configuration Proxy Vite + Django - AgroDiag

## 🎯 Objectif
Faire fonctionner le frontend React et le backend Django ensemble, servis depuis la même origine virtuelle grâce à un proxy Vite.

## 🔧 Configuration

### 1. Proxy Vite (déjà configuré)
Le fichier `frontend/vite.config.mjs` contient :
```javascript
server: {
  port: 3000,
  proxy: {
    '/api': {
      target: 'http://localhost:8000',
      changeOrigin: true,
      secure: false,
    }
  }
}
```

**Comment ça marche :**
- Frontend React tourne sur `http://localhost:3000`
- Backend Django tourne sur `http://localhost:8000`
- Quand le frontend fait un appel à `/api/*`, Vite redirige automatiquement vers `http://localhost:8000/api/*`
- Le frontend "pense" être sur la même origine que l'API

### 2. Lancement des serveurs
Utilisez le fichier `start_servers.bat` qui :
1. Lance Django sur le port 8000
2. Lance React/Vite sur le port 3000
3. Ouvre automatiquement le navigateur sur `http://localhost:3000`

## 🌐 URLs disponibles

- **Frontend (React)** : `http://localhost:3000`
- **Backend (Django)** : `http://localhost:8000`
- **Admin Django** : `http://localhost:8000/admin/`
- **API** : `http://localhost:3000/api/*` (proxy vers Django)

## 🔐 Authentification et Admin

### Détection automatique des utilisateurs admin
Le frontend détecte automatiquement si un utilisateur est admin via :
- `user.is_staff` (utilisateur staff Django)
- `user.is_superuser` (super utilisateur Django)

### Bouton Administration
- **Visible uniquement** pour les utilisateurs admin
- **Localisation** : Menu utilisateur (profil) + Menu mobile
- **Action** : Ouvre `/admin/` dans un nouvel onglet

## 🚀 Workflow de développement

1. **Lancer les serveurs** : `start_servers.bat`
2. **Frontend** : Développez sur `http://localhost:3000`
3. **API** : Les appels `/api/*` passent automatiquement par le proxy
4. **Admin** : Accédez à l'admin Django via `http://localhost:8000/admin/`

## 📱 Avantages de cette configuration

✅ **Même origine virtuelle** : Le frontend et l'API semblent être sur le même serveur
✅ **Pas de CORS** : Les requêtes passent par le proxy Vite
✅ **Développement simplifié** : Un seul navigateur ouvert sur le frontend
✅ **Admin intégré** : Bouton direct vers l'admin Django pour les utilisateurs admin
✅ **Production ready** : Configuration facilement adaptable pour la production

## 🚨 Points d'attention

- **Ports** : Django doit être sur 8000, React sur 3000
- **Proxy** : Seuls les appels commençant par `/api` passent par le proxy
- **Sessions** : Les cookies Django sont partagés via le proxy
- **Hot reload** : Vite gère le hot reload du frontend, Django gère le sien

## 🔄 Production

Pour la production, vous pouvez :
1. **Construire le frontend** : `npm run build`
2. **Servir les fichiers statiques** depuis Django
3. **Configurer nginx** pour servir le frontend et proxy l'API vers Django
4. **Utiliser le même domaine** pour tout

## 🐛 Dépannage

### Le proxy ne fonctionne pas
- Vérifiez que Django tourne sur le port 8000
- Vérifiez que React tourne sur le port 3000
- Redémarrez les deux serveurs

### Erreurs CORS
- Le proxy devrait résoudre les problèmes CORS
- Vérifiez que les appels API commencent par `/api`

### L'admin ne s'affiche pas
- Vérifiez que l'utilisateur a `is_staff=True` dans Django
- Vérifiez que l'utilisateur est connecté
- Vérifiez les logs du navigateur pour les erreurs
