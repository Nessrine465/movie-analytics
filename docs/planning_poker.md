# Planning Poker

## Objectif

Le planning poker est une méthode d’estimation collaborative permettant d’évaluer la complexité des différentes fonctionnalités du projet avant leur développement.

Il permet de prioriser les tâches et d’anticiper les difficultés techniques.

---

## Échelle utilisée

Une échelle de Fibonacci a été utilisée :

- 1 : très simple  
- 2 : simple  
- 3 : complexité modérée  
- 5 : complexe  
- 8 : très complexe  
- 13 : extrêmement complexe  

---

## Backlog des fonctionnalités

- F1 : Bootstrap stack ELK  
- F2 : Ingestion brute des données  
- F3 : Nettoyage et normalisation des données  
- F4 : Mapping et contrôle qualité  
- F5 : Requêtes analytiques Elasticsearch  
- F6 : Dashboard Kibana  
- F7 : Documentation technique  
- F8 : Mini moteur de recherche  

---

## Estimations

| Feature | Estimation initiale | Estimation finale |
|-------- |-------------------  |------------------ |
| F1      | 2                   | 3                 |
| F2      | 3                   | 5                 |
| F3      | 5                   | 5                 |
| F4      | 3                   | 3                 |
| F5      | 2                   | 3                 |
| F6      | 3                   | 5                 |
| F7      | 2                   | 3                 |
| F8      | 5                   | 8                 |

---

## Analyse des écarts

Certaines estimations ont évolué au cours du projet :

- F2 (ingestion) : complexité plus élevée que prévue à cause de la configuration Logstash  
- F6 (Kibana) : ajustements nécessaires pour les visualisations et les types de champs  
- F8 (moteur de recherche) : difficulté liée à l’implémentation et à l’intégration avec Elasticsearch  

Ces ajustements reflètent les difficultés techniques rencontrées en cours de projet.

---

## Hypothèses

- Le dataset est exploitable sans transformation complexe  
- Logstash permet un parsing direct des données  
- Elasticsearch accepte les mappings sans conflits  
- Kibana permet de créer des visualisations sans configuration avancée  

---

## Répartition des fonctionnalités

Le projet a été réalisé en équipe de 3 personnes.

La répartition des tâches a été organisée comme suit :

- Harrold:
  - F1 : Bootstrap stack ELK  
  - F2 : Ingestion brute 
  - Document de 5 pages  

- Nessrine :
  - F4 : Mapping et qualité 
  - F5 : Requêtes Elasticsearch 
  - F7 : Documentation

- Melissa :
 - F3 : Nettoyage des données 
 - F8 : moteur de recherche
 - demo.gif
 - demo_script

---

## Conclusion

Le planning poker a permis d’organiser efficacement le projet, de prioriser les tâches et d’anticiper les difficultés techniques.

Il a également permis d’adapter les estimations en fonction de la complexité réelle rencontrée lors du développement.