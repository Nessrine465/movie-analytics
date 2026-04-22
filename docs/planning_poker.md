# Planning Poker — Movies Data Platform

## Équipe
- **Lead** : Membre 1
- Membre 2
- Membre 3
- Membre 4

## Échelle Fibonacci utilisée
`1 · 2 · 3 · 5 · 8 · 13`

---

## Backlog & Estimations

| ID | Feature | M1 | M2 | M3 | M4 | Retenu | Responsable |
|---|---|---|---|---|---|---|---|
| F1 | Bootstrap stack ELK (docker-compose, scripts) | 3 | 3 | 5 | 3 | **3** | Membre 1 |
| F2 | Ingestion brute movies_raw | 5 | 5 | 3 | 5 | **5** | Membre 2 |
| F3 | Nettoyage & normalisation (Logstash) | 8 | 8 | 13 | 8 | **8** | Membre 3 |
| F4 | Mapping Elasticsearch + analyzer | 5 | 3 | 5 | 5 | **5** | Membre 3 |
| F5 | 12 requêtes DSL commentées | 5 | 8 | 5 | 5 | **5** | Membre 4 |
| F6 | Dashboard Kibana (6-8 visualisations) | 8 | 8 | 5 | 8 | **8** | Membre 4 |
| F7 | Documentation complète (docs/) | 5 | 5 | 5 | 8 | **5** | Membre 1 |
| F8 | Moteur de recherche (UI + ES) | 5 | 5 | 8 | 5 | **5** | Membre 2 |

**Total estimé : 44 points**

---

## Hypothèses retenues

- F3 estimé à 8 car le format `-` des listes demande du Ruby dans Logstash
- F6 estimé à 8 car la création de chaque visualisation Kibana est manuelle
- F1 inclut les scripts `start.sh`, `stop.sh`, `health.sh`
- F4 inclut la création du mapping ET les tests de l'analyzer personnalisé

---

## Répartition par membre

| Membre | Features | Points |
|---|---|---|
| Membre 1 (Lead) | F1, F7 | 8 |
| Membre 2 | F2, F8 | 10 |
| Membre 3 | F3, F4 | 13 |
| Membre 4 | F5, F6 | 13 |
