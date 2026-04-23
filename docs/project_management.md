# Gestion de projet

## Objectif

Ce document présente l’organisation du projet, le workflow Git utilisé, ainsi que la manière dont les différentes tâches ont été structurées et suivies tout au long du développement.

L’objectif était de garantir un travail traçable, clair et reproductible.

---

## Organisation du dépôt

Le projet a été réalisé dans un dépôt Git public, conformément aux consignes.

L’organisation du travail a reposé sur un dépôt centralisé avec une séparation claire entre les branches stables, les branches d’intégration et les branches de développement.

Le dépôt contient également les pipelines Logstash, les fichiers de configuration Docker ainsi que la documentation complète du projet.
---

## Gitflow utilisé

Le projet suit une organisation de type Gitflow simple :

- `main` : version stable du projet
- `dev` : branche d’intégration
- `feature/<id>-<slug>` : branches de développement par fonctionnalité

Cette structure permet de développer chaque partie du projet séparément avant son intégration dans `dev`.

---

## Branches utilisées

Les principales branches utilisées dans le projet sont les suivantes :

- `feature/f1-bootstrap-stack`
- `feature/f2-ingestion-csv`
- `feature/f3-movies-clean`
- `feature/f4-mapping-quality`
- `feature/f5-queries-doc`
- `feature/f6-kibana-dashboard`
- `feature/f7-documentation`

Ces branches ont permis d’isoler les développements par étape du projet.

---

## Pull Requests

Les intégrations ont été réalisées via des Pull Requests, afin d’assurer une meilleure traçabilité des modifications.

Chaque fonctionnalité a été développée dans une branche dédiée avant d’être proposée à l’intégration dans `dev`.

Ce fonctionnement permet :

- d’éviter les modifications directes sur les branches principales
- de conserver un historique clair
- de centraliser les modifications avant leur intégration


---

## Répartition du travail

Le projet a été découpé en plusieurs fonctionnalités principales :

- F1 : mise en place de la stack ELK
- F2 : ingestion brute du dataset
- F3 : nettoyage et création de `movies_clean`
- F4 : mapping et qualité des données
- F5 : requêtes analytiques Elasticsearch
- F6 : visualisations et dashboard Kibana
- F7 : documentation technique et fonctionnelle
- F8 : mini moteur de recherche

Cette organisation a permis d’avancer progressivement, en suivant le backlog demandé dans le sujet.

---

## Traçabilité

Le travail a été rendu traçable grâce à :

- l’utilisation de branches distinctes par fonctionnalité
- des commits explicites
- des Pull Requests pour les intégrations
- une documentation progressive dans le dossier `docs/`

Cette méthode permet de suivre les choix techniques et les étapes de réalisation du projet.

---

## Conclusion

- L’organisation mise en place a permis de structurer le projet de manière claire, progressive et traçable.

- L’utilisation d’un workflow Git basé sur `main`, `dev` et des branches `feature/` a facilité le suivi du travail, l’intégration des fonctionnalités et la qualité globale du projet final.

- Une estimation des tâches a également été réalisée via la méthode du planning poker (voir `docs/planning_poker.md`), permettant de prioriser les fonctionnalités et d’anticiper les difficultés techniques.