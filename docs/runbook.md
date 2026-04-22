# Runbook Technique — Movies Data Platform

## Prérequis

- Docker >= 24.x
- Docker Compose >= 2.x
- RAM disponible : minimum 4 Go
- Espace disque : minimum 5 Go
- Fichier `DATA/movies.csv` présent à la racine

---

## Installation & Démarrage

```bash
# 1. Cloner le dépôt
git clone https://github.com/<votre-org>/elk-movies.git
cd elk-movies

# 2. Placer le dataset
cp /path/to/movies.csv DATA/movies.csv

# 3. Rendre les scripts exécutables
chmod +x start.sh stop.sh health.sh

# 4. Démarrer la stack
./start.sh
```

Le script `start.sh` :
- Lance Elasticsearch et Kibana
- Attend leur disponibilité
- Crée le mapping `movies_clean`
- Lance Logstash pour l'ingestion

---

## Vérification de l'ingestion

```bash
# Nombre de documents ingérés
curl http://localhost:9200/movies_raw/_count
curl http://localhost:9200/movies_clean/_count

# Échantillon d'un document
curl "http://localhost:9200/movies_clean/_search?size=1&pretty"

# Health check complet
./health.sh
```

---

## Accès aux interfaces

| Service | URL |
|---|---|
| Elasticsearch | http://localhost:9200 |
| Kibana | http://localhost:5601 |
| Moteur de recherche | Ouvrir `search-engine/index.html` dans un navigateur |

---

## Arrêt de la stack

```bash
./stop.sh
```

---

## Réinitialisation complète

```bash
# Arrêter et supprimer les volumes
docker-compose down -v

# Relancer
./start.sh
```

---

## Importer le dashboard Kibana

1. Aller dans Kibana → Stack Management → Saved Objects
2. Cliquer sur **Import**
3. Sélectionner `docs/kibana_export.ndjson`
4. Confirmer l'import

---

## Dépannage courant

| Symptôme | Cause probable | Solution |
|---|---|---|
| ES ne démarre pas | Pas assez de RAM | Réduire `ES_JAVA_OPTS` à `-Xms512m -Xmx512m` |
| `vm.max_map_count` error | Limite kernel Linux trop basse | `sudo sysctl -w vm.max_map_count=262144` |
| Logstash ne lit pas le CSV | Chemin `/data` non monté | Vérifier que `DATA/movies.csv` existe |
| `movies_clean` mapping error | Index déjà existant avec mauvais mapping | `curl -X DELETE localhost:9200/movies_clean` puis relancer |
| Kibana unreachable | ES pas encore prêt | Attendre 30s supplémentaires |
