# Movie-analytics

Projet d’analyse de films avec la stack ELK.

## Stack utilisée
- Elasticsearch
- Logstash
- Kibana
- Docker Compose

## Objectif
- démarrer la stack ELK localement
- ingérer un dataset de films  
- créer un index brut `movies_raw`
- nettoyer les données pour créer `movies_clean`
- produire des visualisations dans Kibana
- faire un mini moteur de recherche

## Lancement du projet
Depuis le dossier du projet :

```bash
docker compose up -d
```
## Vérifier que les services fonctionnent
Vérifier les conteneurs :

```bash
docker compose ps
```
- Vérifier Elasticsearch : http://localhost:9200
- Vérifier Kibana : http://localhost:5601

## Arrêter la stack
Depuis le dossier du projet :

```bash
docker compose down
```


