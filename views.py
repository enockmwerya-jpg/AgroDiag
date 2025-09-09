"""
Vues principales pour le projet AgroDiag.
"""
from django.http import HttpResponse

def home(request):
    """
    Vue pour la page d'accueil du backend.
    Affiche un lien pour retourner vers l'application frontend.
    """
    html_content = """
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <title>Backend AgroDiag</title>
        <style>
            body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #f4f4f4; }
            a { text-decoration: none; font-size: 1.5rem; color: #2e7d32; padding: 1rem 2rem; border: 2px solid #2e7d32; border-radius: 8px; transition: all 0.3s ease; }
            a:hover { background-color: #2e7d32; color: white; }
        </style>
    </head>
    <body>
        <a href="http://localhost:3000" title="Retour à l'application">← Retour</a>
    </body>
    </html>
    """
    return HttpResponse(html_content)