## Runbook 

## Objectif

Ce document explique comment installer, lancer et vérifier le bon fonctionnement du projet **Movie-analytics** basé sur la stack ELK.

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
## Lancement de la stack

Pour démarrer les services :

```bash
docker-compose up -d --build
```
## Services attendus

Les services attendus sont :

1. Elasticsearch
2. Kibana
3. Logstash
---
## Vérification des services

- Vérifier Elasticsearch, accéder à l’URL suivante : ` http://localhost:9200`

- Vérifier Kibana, accéder à l’URL suivante : `http://localhost:5601` 

## Vérification des index: 

dans Kibana, aller dans Dev Tools puis exécuter :
```Js
GET _cat/indices?v
```
Les index suivants doivent apparaître :
 - movies_raw
 - movies_clean

## Vérification des données

Dans Kibana → Dev Tools

1. Données brutes : `GET movies_raw/_search?size=2` 
2. Données nettoyées : `GET movies_clean/_search?size=2` 

## Configuration de Kibana (Data View)

Avant d’utiliser le dashboard, il faut créer une Data View :

1. aller dans Stack Management
2. cliquer sur Data Views
3. cliquer sur Create data view
4. entrer :
    - Name : movies_clean
    - Index pattern : movies_clean
5. valider

## Import du dashboard Kibana

Pour importer le dashboard :

1. ouvrir Kibana
2. aller dans Stack Management
3. ouvrir Saved Objects
4. cliquer sur Import
5. sélectionner le fichier : Kibana/export/movies_dashboard.ndjson

## érification du dashboard
1. aller dans Dashboard
2. ouvrir le dashboard importé
3. érifier que les visualisations s’affichent correctement
Si certaines visualisations sont vides :
 - vérifier que l’index movies_clean contient des données
 - vérifier que la Data View est bien configurée

## Arrêt des services

Pour arrêter la stack :

`docker-compose down`

## Remarques

- Le projet dépend de la présence du fichier `movies.csv` dans le dossier `DATA/`
- Les données doivent être ingérées avant d’utiliser Kibana
- Le dashboard dépend de l’index movies_clean
- Les champs utilisés dans Kibana doivent être compatibles avec les agrégations (ex : .keyword pour les champs texte)
- Le projet utilise un index brut `movies_raw` et un index nettoyé `movies_clean`