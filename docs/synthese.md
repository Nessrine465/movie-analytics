# Document de Synthèse
## Movies Data Platform — Stack ELK
### Projet d'examen | Équipe de 4

---

## 1. Contexte, Objectifs et Périmètre

### Problème traité
Le projet vise à construire une plateforme complète d'analyse et de recherche de films à partir d'un dataset de grande taille (~769 000 films). La problématique centrale est la suivante : comment ingérer, nettoyer et valoriser un dataset hétérogène et partiellement incomplet pour en extraire des insights métier exploitables ?

### Objectifs techniques
- Déployer une stack ELK reproductible via Docker Compose
- Ingérer les données brutes dans un index `movies_raw`
- Nettoyer et typer les données dans un index `movies_clean` avec mapping explicite
- Produire 12 requêtes analytiques documentées (dont 5 requêtes bool)
- Construire un dashboard Kibana de 8 visualisations répondant à des questions métier
- Livrer un mini moteur de recherche connecté à Elasticsearch

### Objectifs métier
- Permettre l'exploration du catalogue films par genre, langue, période et popularité
- Mesurer la qualité des données disponibles (budget, revenue, notes)
- Faciliter la recommandation de films via une interface de recherche

### Périmètre réalisé
| Feature | Statut |
|---|---|
| F1 - Bootstrap stack | ✅ Réalisé |
| F2 - Ingestion brute `movies_raw` | ✅ Réalisé |
| F3 - Nettoyage & normalisation | ✅ Réalisé |
| F4 - Mapping & analyzer personnalisé | ✅ Réalisé |
| F5 - 12 requêtes DSL | ✅ Réalisé |
| F6 - Dashboard Kibana | ✅ Réalisé |
| F7 - Documentation complète | ✅ Réalisé |
| F8 - Moteur de recherche | ✅ Réalisé |

---

## 2. Architecture et Environnement

### Stack technique
```
┌──────────────────────────────────────────────────────┐
│                  Docker Compose                       │
│                                                      │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────┐ │
│  │Logstash  │──►│Elastic-  │◄──│    Kibana         │ │
│  │:5044     │   │search    │   │    :5601          │ │
│  │          │   │:9200     │   │                  │ │
│  └────┬─────┘   └──────────┘   └──────────────────┘ │
│       │              ▲                              │
└───────┼──────────────┼──────────────────────────────┘
        │              │
   /data/movies.csv    └── search-engine/index.html
   (volume ro)              (navigateur)
```

### Description du docker-compose
Trois services sont définis dans `docker-compose.yml` :

- **Elasticsearch 8.13.0** : moteur de stockage et d'indexation, exposé sur le port 9200. Configuré en mode single-node avec sécurité désactivée pour simplifier le développement. Un volume persistant `es_data` stocke les données entre les redémarrages.
- **Kibana 8.13.0** : interface de visualisation, exposée sur le port 5601. Dépend d'Elasticsearch via healthcheck.
- **Logstash 8.13.0** : pipeline ETL. Monte le dossier `DATA/` en lecture seule (`ro`) et la configuration en lecture seule. Lance l'ingestion automatiquement au démarrage.

### Flux de données
```
movies.csv
  → Logstash (parse CSV, conversion types, split listes, suppression invalides)
    → movies_raw  (données brutes, tous les documents)
    → movies_clean (données nettoyées, mapping explicite, qualité calculée)
      → Kibana (data view "movies_clean" → Lens → Dashboard)
      → search-engine/index.html (requêtes API directes vers ES)
```

---

## 3. Données et Nettoyage

### Description des colonnes principales
Le dataset contient 20 colonnes couvrant l'identité du film (`id`, `title`, `original_language`), ses métadonnées commerciales (`budget`, `revenue`, `status`), ses caractéristiques éditoriales (`genres`, `keywords`, `overview`, `tagline`), ses indicateurs de popularité (`vote_average`, `vote_count`, `popularity`), et ses données techniques (`runtime`, `release_date`, `credits`, `production_companies`).

### Anomalies détectées

**Anomalies de types :**
Les champs numériques `budget`, `revenue` et `runtime` sont encodés en `float64` dans le CSV (ex : `137.0` pour une durée, `70000000.0` pour un budget). Ils doivent être convertis en types entiers ou longs. La `release_date` est une chaîne de caractères au format `yyyy-MM-dd` et doit être parsée en objet date pour permettre les requêtes de plage temporelle.

**Anomalies de valeurs :**
Les champs `budget` et `revenue` contiennent massivement des valeurs à `0.0`, qui ne représentent pas une donnée réelle mais une donnée manquante (le dataset utilise 0 comme valeur nulle). Sur un échantillon de 1000 films, environ 65% des budgets et 70% des revenus sont à zéro. Ces valeurs sont supprimées lors du nettoyage plutôt que conservées, pour ne pas fausser les agrégations et statistiques.

Le champ `tagline` est absent pour environ 31% des films, et `keywords` pour environ 19%.

**Anomalies de format :**
Les champs liste (`genres`, `credits`, `keywords`, `production_companies`) utilisent le séparateur `-` et non un format JSON. Exemple : `"Action-Adventure-Fantasy"`, `"Alexander Skarsgård-Nicole Kidman-Claes Bang"`. Ces champs sont splitté sur `-` puis nettoyés (strip + suppression des chaînes vides) pour produire de véritables tableaux indexables.

### Règles Logstash appliquées
1. **Suppression de l'en-tête** : la ligne `id,title,...` est droppée via `if [id] == "id"`.
2. **Conversion de types** : bloc `mutate { convert }` pour tous les champs numériques.
3. **Parsing date** : filtre `date { match => ["release_date", "yyyy-MM-dd"] }`.
4. **Split des listes** : `mutate { split => { "genres" => "-" } }` suivi d'un `ruby` pour le nettoyage.
5. **Suppression des invalides** : conditions `if [budget] <= 0` pour retirer les valeurs nulles déguisées.
6. **Score qualité** : un bloc `ruby` calcule `data_quality_score` et `data_quality_issues` pour chaque document.

### Mesure d'impact avant / après

| Indicateur | movies_raw | movies_clean |
|---|---|---|
| Nombre de documents | ~769 631 | ~769 631 |
| Type de `release_date` | string | date (requêtes range possibles) |
| Type de `genres` | string | keyword[] (agrégations possibles) |
| Champ `budget` (présence) | ~100% (dont 65% à 0) | ~35% (valeurs réelles uniquement) |
| Champ `revenue` (présence) | ~100% (dont 70% à 0) | ~30% (valeurs réelles uniquement) |
| Score qualité moyen | — | ~60/100 |
| Documents avec données financières complètes | ~30% | ~25% |

---

## 4. Modélisation Elasticsearch

### Mapping de movies_clean
Le mapping définit 22 champs avec des types explicites. Les choix clés sont :

- `title` : type `text` avec analyzer `movie_analyzer` pour la recherche full-text, plus un sous-champ `keyword` pour les tris et agrégations, et un sous-champ `autocomplete` avec edge n-gram pour la complétion automatique.
- `genres`, `original_language`, `status`, `credits`, `keywords` : type `keyword` pour permettre les agrégations exactes et les filtres par terme.
- `overview`, `tagline` : type `text` avec l'analyzer personnalisé pour la recherche sémantique.
- `release_date` : type `date` avec format `strict_date_optional_time||yyyy-MM-dd`.
- `budget`, `revenue` : type `long` (les valeurs peuvent dépasser 2 milliards).
- `poster_path`, `backdrop_path` : type `keyword` avec `index: false` car ces champs ne servent qu'à l'affichage et n'ont pas besoin d'être recherchables.

### Analyzer personnalisé : `movie_analyzer`
```json
{
  "type": "custom",
  "tokenizer": "standard",
  "filter": ["lowercase", "asciifolding", "movie_stop", "movie_stemmer"]
}
```
**Justification** : Le tokenizer `standard` segmente sur les espaces et la ponctuation. Le filtre `asciifolding` normalise les accents (ex : "Élémentaire" → "elementaire"), permettant la recherche sans accent. Le filtre `stop` supprime les mots vides anglais pour réduire le bruit. Le `stemmer` (English) ramène les mots à leur racine (ex : "running" → "run"), améliorant le recall.

Un second analyzer `autocomplete_analyzer` utilise un filtre `edge_ngram` (min 2, max 20 caractères) pour la complétion de titres en temps réel.

---

## 5. Requêtes et Analyses

### Vue d'ensemble des requêtes
Les 12 requêtes couvrent trois grandes familles d'usage :
- **Filtrage qualitatif** (Q1 à Q5 : requêtes bool) : films bien notés, films populaires par genre, anomalies de données, films des années 90, recherche full-text.
- **Analytique agrégée** (Q6 à Q9) : classements, distributions par langue et par genre, évolution temporelle.
- **Calculs avancés** (Q10 à Q12) : ROI par script, mesure de qualité, statistiques globales.

### Requête bool emblématique (Q5 — moteur de recherche)
La requête `multi_match` sur les champs `["title^3", "overview^2", "tagline", "keywords"]` avec `fuzziness: AUTO` constitue le cœur du moteur de recherche. Le boost sur `title` (×3) privilégie les correspondances dans le titre, tandis que la fuzziness tolère les fautes de frappe. Des clauses `should` avec boost sur la note et la popularité permettent de remonter les films de qualité dans les résultats.

### Exemples de résultats valides
- Q1 (films anglais bien notés) : "The Shawshank Redemption" (9.2), "The Godfather" (8.7)
- Q2 (Action/SF populaires) : "Spider-Man: No Way Home", "Avengers: Endgame"
- Q10 (meilleur ROI) : films d'horreur à faible budget et fort revenu

---

## 6. Dashboard Kibana et Lecture Métier

### Visualisations produites
Le dashboard `Movies Analytics Dashboard` contient 8 visualisations :
1. **Films par genre** → Drama et Comedy dominent le catalogue en volume
2. **Évolution par année** → Croissance exponentielle des productions depuis 2000
3. **Note moyenne par genre** → Documentary et History obtiennent les meilleures notes moyennes
4. **Répartition par langue** → L'anglais représente ~65% du catalogue
5. **Top 10 popularité** → Dominé par les franchises Marvel et DC récentes
6. **Score qualité moyen** → ~60/100 indique un dataset partiellement incomplet
7. **Budget moyen par genre** → Action et Animation affichent les budgets les plus élevés
8. **Distribution des notes** → Distribution en cloche centrée autour de 6.0-6.5

### Limites d'interprétation
La popularité TMDB est un score calculé dynamiquement qui favorise les films récents, ce qui biaise le classement vers les sorties 2020-2022. Les statistiques financières (budget, revenue) ne concernent que ~30% des films, ce qui rend les comparaisons par genre peu représentatives pour les petits genres. Les films sans `vote_count` significatif (< 10 votes) peuvent avoir des notes extrêmes peu fiables.

---

## 7. Gestion de Projet et Collaboration

### Gitflow respecté
La branche `main` reçoit uniquement les versions stables via PR depuis `dev`. La branche `dev` intègre les features via PR. Chaque feature est développée dans une branche dédiée nommée `feature/<id>-<slug>`. Aucun push direct n'est autorisé sur `main` ou `dev`.

### Planning poker
Le backlog de 8 features a été estimé en équipe avec l'échelle Fibonacci. La feature la plus complexe est F3 (Nettoyage, 8 points) en raison du format non-standard des champs liste. Le total estimé est de 44 points de story.

### Répartition des responsabilités
Chaque membre est responsable d'au minimum 2 features, a ouvert au moins 1 PR et reviewé au moins 1 PR. Le lead technique a assuré la cohérence architecturale et la documentation finale.

---

## 8. Bilan, Limites et Améliorations

### Points réussis
- La stack ELK démarre de manière entièrement automatisée grâce au script `start.sh`
- Le pipeline Logstash gère les cas limites (champs vides, valeurs à 0, formats heterogènes)
- Le moteur de recherche offre une expérience utilisateur soignée avec affichage des affiches TMDB
- Le score qualité automatique permet une analyse immédiate de la complétude des données

### Points bloquants rencontrés
- Le séparateur `-` dans les champs liste crée des ambiguïtés pour les noms d'acteurs contenant un tiret (ex : "Jean-Paul Belmondo" est splitté en deux tokens). Une solution serait d'utiliser un autre séparateur ou un encodage JSON.
- L'ingestion de ~769 000 documents par Logstash prend un temps significatif (~15-30 minutes selon la machine).
- La visualisation des données financières est limitée par le faible taux de remplissage des champs `budget` et `revenue`.

### Axes d'amélioration
1. **Qualité des données** : enrichir le dataset via l'API TMDB pour compléter les budgets manquants
2. **Performance** : ajouter plusieurs shards pour les requêtes analytiques sur 700k+ documents
3. **Moteur de recherche** : ajouter une pagination, un historique de recherche et une suggestion en temps réel via l'analyzer `autocomplete`
4. **Sécurité** : activer `xpack.security` avec authentification pour un déploiement production
5. **Monitoring** : intégrer un dashboard de monitoring Logstash pour suivre le débit d'ingestion
