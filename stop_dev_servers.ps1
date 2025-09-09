# Script PowerShell pour arrêter les serveurs de développement AgroDiag
# Exécution: .\stop_dev_servers.ps1

# Couleurs pour l'affichage
$Colors = @{
    Info = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
}

function Write-ColoredOutput {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    Write-Host $Message -ForegroundColor $Colors[$Type]
}

function Stop-ServerOnPort {
    param(
        [int]$Port,
        [string]$ServerName
    )
    
    try {
        $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
        
        if ($connections) {
            $processes = $connections | Select-Object -ExpandProperty OwningProcess -Unique
            
            foreach ($processId in $processes) {
                try {
                    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
                    if ($process) {
                        Write-ColoredOutput "🛑 Arrêt du serveur $ServerName (PID: $processId, Port: $Port)" "Info"
                        Stop-Process -Id $processId -Force
                        Write-ColoredOutput "✅ Serveur $ServerName arrêté" "Success"
                    }
                } catch {
                    Write-ColoredOutput "⚠️ Processus $processId déjà arrêté" "Warning"
                }
            }
        } else {
            Write-ColoredOutput "ℹ️ Aucun serveur $ServerName actif sur le port $Port" "Info"
        }
    } catch {
        Write-ColoredOutput "❌ Erreur lors de l'arrêt du serveur $ServerName : $_" "Error"
    }
}

function Stop-AllNodeProcesses {
    Write-ColoredOutput "🛑 Arrêt des processus Node.js restants..." "Info"
    
    try {
        $nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
        
        if ($nodeProcesses) {
            foreach ($process in $nodeProcesses) {
                try {
                    # Vérifier si c'est un processus lié à notre projet
                    $commandLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($process.Id)" -ErrorAction SilentlyContinue).CommandLine
                    
                    if ($commandLine -and ($commandLine -like "*vite*" -or $commandLine -like "*npm start*" -or $commandLine -like "*localhost:3000*")) {
                        Write-ColoredOutput "🛑 Arrêt du processus Node.js (PID: $($process.Id)): $commandLine" "Info"
                        Stop-Process -Id $process.Id -Force
                        Write-ColoredOutput "✅ Processus Node.js arrêté" "Success"
                    }
                } catch {
                    Write-ColoredOutput "⚠️ Impossible d'arrêter le processus Node.js (PID: $($process.Id))" "Warning"
                }
            }
        } else {
            Write-ColoredOutput "ℹ️ Aucun processus Node.js actif" "Info"
        }
    } catch {
        Write-ColoredOutput "❌ Erreur lors de l'arrêt des processus Node.js: $_" "Error"
    }
}

function Stop-AllPythonProcesses {
    Write-ColoredOutput "🛑 Arrêt des processus Python/Django restants..." "Info"
    
    try {
        $pythonProcesses = Get-Process -Name "python" -ErrorAction SilentlyContinue
        
        if ($pythonProcesses) {
            foreach ($process in $pythonProcesses) {
                try {
                    # Vérifier si c'est un processus Django
                    $commandLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($process.Id)" -ErrorAction SilentlyContinue).CommandLine
                    
                    if ($commandLine -and ($commandLine -like "*manage.py*" -or $commandLine -like "*runserver*" -or $commandLine -like "*8000*")) {
                        Write-ColoredOutput "🛑 Arrêt du processus Django (PID: $($process.Id)): $commandLine" "Info"
                        Stop-Process -Id $process.Id -Force
                        Write-ColoredOutput "✅ Processus Django arrêté" "Success"
                    }
                } catch {
                    Write-ColoredOutput "⚠️ Impossible d'arrêter le processus Python (PID: $($process.Id))" "Warning"
                }
            }
        } else {
            Write-ColoredOutput "ℹ️ Aucun processus Python actif" "Info"
        }
    } catch {
        Write-ColoredOutput "❌ Erreur lors de l'arrêt des processus Python: $_" "Error"
    }
}

# Fonction principale
function Main {
    Write-ColoredOutput "🚀 AgroDiag - Arrêt des serveurs de développement" "Info"
    Write-ColoredOutput "=" * 60 "Info"
    
    # Arrêter les serveurs par port
    Stop-ServerOnPort -Port 8000 -ServerName "Django"
    Stop-ServerOnPort -Port 3000 -ServerName "Vite"
    
    # Attendre un peu pour laisser les processus se fermer proprement
    Start-Sleep -Seconds 2
    
    # Arrêter les processus restants
    Stop-AllNodeProcesses
    Stop-AllPythonProcesses
    
    Write-ColoredOutput "" "Info"
    Write-ColoredOutput "=" * 60 "Info"
    Write-ColoredOutput "🎉 Tous les serveurs ont été arrêtés" "Success"
    Write-ColoredOutput "=" * 60 "Info"
}

# Exécution du script principal
try {
    Main
} catch {
    Write-ColoredOutput "❌ Erreur inattendue: $_" "Error"
    exit 1
}

Write-ColoredOutput "✅ Script terminé" "Success"
