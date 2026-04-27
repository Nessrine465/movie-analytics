docker rm -f cors-proxy
docker run -d --name cors-proxy -p 9201:9201 -v "C:\Users\DELL\Downloads\movie-analytics\search-engine:/app" --network "movie-analytics_elk" python:3.11-slim python /app/proxy.py
5. Lancer le serveur web local

Depuis le dossier search-engine :

cd "C:\Users\DELL\Downloads\movie-analytics\search-engine"
python -m http.server 8080

Cette commande permet d’héberger localement l’interface web.

6. Accéder à l’application

Ouvrir le navigateur et aller sur :

http://localhost:8080/index.html
7. Tester une recherche

Exemple de test :

Recherche : avatar
Langue : Toutes les langues
Genre : Tous les genres

Puis cliquer sur Rechercher.

L’application envoie une requête vers Elasticsearch via le proxy, puis affiche les films correspondants.

8. Vérifier Kibana

Kibana est accessible à l’adresse suivante :

http://localhost:5601

Il permet de vérifier que les données sont bien présentes dans Elasticsearch et d’explorer l’index movies_clean.

9. Problèmes possibles
La page est blanche

Vérifier que le serveur Python est bien lancé :

python -m http.server 8080
Aucun résultat ne s’affiche

Vérifier que le proxy tourne :

docker ps

Puis vérifier les logs :

docker logs cors-proxy
Conflit de conteneur

Si Docker affiche une erreur du type :

The container name "/elasticsearch" is already in use

Supprimer les anciens conteneurs :

docker rm -f elasticsearch kibana logstash

Puis relancer :

docker-compose up -d