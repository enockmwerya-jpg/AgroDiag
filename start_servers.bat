@echo off
echo 🚀 Demarrage des serveurs AgroDiag...
echo.
echo 📋 Configuration:
echo    - Backend Django: http://localhost:8000
echo    - Frontend React: http://localhost:3000 (avec proxy vers /api)
echo    - Admin Django: http://localhost:8000/admin/
echo.

REM Demarrer Django en arriere-plan
echo 🐍 Demarrage du serveur Django...
start "Django Backend" cmd /k "cd /d backend && python manage.py runserver 8000"

REM Attendre que Django soit pret
echo ⏳ Attente du serveur Django...
timeout /t 5 /nobreak >nul

REM Demarrer React en arriere-plan  
echo ⚛️ Demarrage du serveur React...
start "React Frontend" cmd /k "cd /d frontend && npm run dev"

REM Attendre que React soit pret
echo ⏳ Attente du serveur React...
timeout /t 8 /nobreak >nul

REM Ouvrir le navigateur automatiquement
echo 🌐 Ouverture du navigateur...
start http://localhost:3000

echo.
echo ✅ Serveurs lancés et navigateur ouvert!
echo.
echo 📱 URLs disponibles:
echo    🌐 Frontend: http://localhost:3000
echo    🐍 Backend: http://localhost:8000
echo    ⚙️  Admin:  http://localhost:8000/admin/
echo.
echo 💡 Le frontend utilise un proxy vers /api pour communiquer avec Django
echo 💡 Les utilisateurs admin verront un bouton "Administration Django"
echo.
echo 🧪 Pour tester la configuration: node frontend/check-proxy.js
echo.
echo Appuyez sur une touche pour fermer cette fenetre...
pause >nul
