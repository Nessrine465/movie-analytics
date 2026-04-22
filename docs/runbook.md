## Runbook 

## Objectif

Ce document explique comment installer, lancer et vérifier le bon fonctionnement du projet **Movies Data Platform** basé sur la stack ELK.

Il permet à une autre personne de relancer le projet sur une machine vierge et de retrouver les principaux livrables.

---

## Prérequis

Avant de lancer le projet, il faut disposer de :

- Docker
- Docker Compose
- Git

---

## Structure du projet

Les principaux éléments du projet sont :

- `docker-compose.yml`
- `logstash/pipeline/`
- `docs/`
- `Kibana/export`
- dossier des données contenant `movies.csv`

---

## Préparation des données

Le projet utilise le fichier `movies.csv`.

Avant de lancer la stack, il faut :

1. télécharger le dataset
2. placer le fichier `movies.csv` dans le dossier `DATA/`

Le pipeline Logstash lit ce fichier pour créer les index Elasticsearch.

---
## Services attendus

Les services attendus sont :

1. Elasticsearch
2. Kibana
3. Logstash
---
## Vérification des services

Vérifier Elasticsearch, accéder à l’URL suivante : ` http://localhost:9200`

Vérifier Kibana, accéder à l’URL suivante : `http://localhost:5601` 

Vérification des index: dans Kibana, aller dans Dev Tools puis exécuter :
`GET _cat/indices?v`

## Vérification des données

1. Données brutes : `GET movies_raw/_search?size=2` 
2. Données nettoyées : `GET movies_clean/_search?size=2` 

## Import du dashboard Kibana

Pour réimporter le dashboard exporté :

1. ouvrir Kibana
2. aller dans Stack Management
3. ouvrir Saved Objects
4. cliquer sur Import
5. sélectionner le fichier .ndjson

Le dashboard repose sur l’index movies_clean.


## Lancement de la stack

Pour démarrer les services :

`docker-compose up --build`

## Arrêt des services

Pour arrêter la stack :

`docker-compose down`

## Remarques

- Le projet dépend de la présence du fichier `movies.csv` dans le dossier `DATA/`
- Le dashboard Kibana nécessite l’import du fichier `.ndjson`
- Les données doivent être ingérées avant de pouvoir utiliser correctement les visualisations
- Le projet utilise un index brut `movies_raw` et un index nettoyé `movies_clean`