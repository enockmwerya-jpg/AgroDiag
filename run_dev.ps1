# Script simple pour lancer AgroDiag en mode développement
Write-Host "🚀 Lancement d'AgroDiag en mode développement" -ForegroundColor Green

# Fonction pour arrêter proprement les serveurs
function Stop-AllServers {
    Write-Host "`n🛑 Arrêt des serveurs..." -ForegroundColor Yellow
    
    # Tuer les processus sur les ports 3000 et 8000
    $ports = @(3000, 8000)
    foreach ($port in $ports) {
        $connections = netstat -ano | Select-String ":$port "
        if ($connections) {
            $pids = ($connections | ForEach-Object { ($_ -split '\s+')[-1] }) | Sort-Object -Unique
            foreach ($pid in $pids) {
                if ($pid -and $pid -ne "0") {
                    try {
                        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
                        Write-Host "✅ Processus $pid arrêté (port $port)" -ForegroundColor Green
                    } catch {
                        # Ignorer les erreurs
                    }
                }
            }
        }
    }
    exit
}

# Gérer Ctrl+C pour arrêt propre
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { Stop-AllServers }

try {
    # Vérifier les prérequis
    Write-Host "🔍 Vérification des prérequis..."
    
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Python non trouvé dans le PATH" -ForegroundColor Red
        exit 1
    }
    
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-Host "❌ npm non trouvé dans le PATH" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ Prérequis OK"
    
    # Arrêter les serveurs existants
    Write-Host "🧹 Nettoyage des serveurs existants..."
    Stop-AllServers -NoExit
    
    # Démarrer le backend Django
    Write-Host "🐍 Démarrage du serveur Django..." -ForegroundColor Cyan
    $djangoJob = Start-Job -ScriptBlock {
        Set-Location "$using:PWD\backend"
        python manage.py runserver 8000
    }
    
    Start-Sleep -Seconds 3
    
    # Démarrer le frontend React
    Write-Host "⚛️ Démarrage du serveur Vite..." -ForegroundColor Magenta
    $viteJob = Start-Job -ScriptBlock {
        Set-Location "$using:PWD\frontend"
        npm start
    }
    
    Write-Host ""
    Write-Host "🎉 Serveurs lancés!" -ForegroundColor Green
    Write-Host "   📱 Backend:  http://localhost:8000" -ForegroundColor White
    Write-Host "   🌐 Frontend: http://localhost:3000" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Appuyez sur Ctrl+C pour arrêter" -ForegroundColor Gray
    
    # Boucle pour maintenir les serveurs
    while ($true) {
        $backendState = (Get-Job $djangoJob).State
        $frontendState = (Get-Job $viteJob).State
        
        if ($backendState -eq "Failed") {
            Write-Host "❌ Serveur Django arrêté" -ForegroundColor Red
            Receive-Job $djangoJob
            break
        }
        
        if ($frontendState -eq "Failed") {
            Write-Host "❌ Serveur Vite arrêté" -ForegroundColor Red  
            Receive-Job $viteJob
            break
        }
        
        Start-Sleep -Seconds 1
    }
    
} catch {
    Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Nettoyer les jobs
    if ($djangoJob) { Stop-Job $djangoJob -Force; Remove-Job $djangoJob -Force }
    if ($viteJob) { Stop-Job $viteJob -Force; Remove-Job $viteJob -Force }
    Stop-AllServers
}
