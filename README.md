# Movies Data Platform

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

## Lancement du projet
Depuis le dossier du projet :

```bash
docker-compose up
