# 🎬 Movies Data Platform — ELK Stack

Plateforme d'analyse de films construite avec la stack **Elasticsearch · Logstash · Kibana**
à partir du dataset [Millions of Movies](https://www.kaggle.com/datasets/akshaypawar7/millions-of-movies/versions/67).

---

## 🏗 Architecture

```
movies.csv
    │
    ▼
┌─────────────┐
│   Logstash  │  ← parse + nettoie + type les données
└──────┬──────┘
       │
       ├──► movies_raw    (ingestion brute)
       │
       └──► movies_clean  (données nettoyées + mapping explicite)
                │
                ▼
         ┌──────────┐     ┌──────────────────┐
         │  Kibana  │     │ Moteur de recherche│
         │ Dashboard│     │  search-engine/   │
         └──────────┘     └──────────────────┘
```

---

## 📁 Structure du projet

```
elk-movies/
├── docker-compose.yml              # Stack ELK complète
├── start.sh                        # Démarrage + création mapping
├── stop.sh                         # Arrêt propre
├── health.sh                       # Vérification de l'état
├── DATA/
│   └── movies.csv                  # Dataset (à placer ici)
├── logstash/
│   ├── config/logstash.yml
│   └── pipeline/logstash.conf      # Pipeline parse + clean
├── elasticsearch/
│   └── mapping_movies_clean.json   # Mapping explicite avec analyzers
├── search-engine/
│   └── index.html                  # Mini moteur de recherche UI
└── docs/
    ├── data_dictionary.md          # Dictionnaire des colonnes
    ├── data_cleaning.md            # Règles de nettoyage + mesures
    ├── queries.md                  # 12 requêtes DSL commentées
    ├── runbook.md                  # Runbook technique
    ├── planning_poker.md           # Backlog + estimations
    ├── project_management.md       # Organisation + Gitflow
    ├── demo_script.md              # Script de démonstration
    ├── demo.gif                    # GIF de démonstration (à générer)
    └── kibana_export.ndjson        # Export dashboard (après création)
```

---

## 🚀 Démarrage rapide

### Prérequis
- Docker >= 24.x
- Docker Compose >= 2.x
- RAM : 4 Go minimum
- Disque : 5 Go minimum

### Installation

```bash
# 1. Cloner le repo
git clone https://github.com/<votre-org>/elk-movies.git
cd elk-movies

# 2. Placer le dataset
cp /path/to/movies.csv DATA/movies.csv

# 3. Lancer
chmod +x start.sh stop.sh health.sh
./start.sh
```

### Vérification

```bash
./health.sh
# Elasticsearch : http://localhost:9200
# Kibana        : http://localhost:5601
```

### Moteur de recherche

Ouvrir `search-engine/index.html` dans un navigateur.

---

## 📊 Dataset

| Métrique | Valeur |
|---|---|
| Nombre de films | ~769 631 |
| Colonnes | 20 |
| Taille brute | ~373 MB |
| Période couverte | 1874 – 2022 |

---

## 👥 Équipe

| Membre | Rôle | Features |
|---|---|---|
| Membre 1 | Lead Technique | F1, F7 |
| Membre 2 | Dev Backend | F2, F8 |
| Membre 3 | Dev Data | F3, F4 |
| Membre 4 | Dev Analytics | F5, F6 |

---

## 🔗 Liens utiles

- [Kibana](http://localhost:5601)
- [Elasticsearch](http://localhost:9200)
- [Documentation](./docs/runbook.md)
