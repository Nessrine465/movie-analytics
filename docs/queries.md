# Requêtes Elasticsearch — Movies Data Platform
# 12 requêtes DSL commentées (dont 5 bool)

---

## ── REQUÊTES BOOL (5 obligatoires) ────────────────────────

### Q1 — Films anglais bien notés sortis après 2010
```json
GET movies_clean/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "original_language": "en" } }
      ],
      "filter": [
        { "range": { "vote_average": { "gte": 7.5 } } },
        { "range": { "release_date": { "gte": "2010-01-01" } } },
        { "range": { "vote_count":   { "gte": 500 } } }
      ]
    }
  },
  "sort": [{ "vote_average": "desc" }],
  "size": 10
}
```
> **Métier** : Identifier les films anglophones récents à forte note pour une recommandation qualité.

---

### Q2 — Films Action ou Sci-Fi très populaires
```json
GET movies_clean/_search
{
  "query": {
    "bool": {
      "should": [
        { "term": { "genres": "Action" } },
        { "term": { "genres": "Science Fiction" } }
      ],
      "minimum_should_match": 1,
      "filter": [
        { "range": { "popularity": { "gte": 100 } } },
        { "term":  { "status": "Released" } }
      ]
    }
  },
  "sort": [{ "popularity": "desc" }],
  "size": 10
}
```
> **Métier** : Films blockbusters d'action/SF pour une page "tendances".

---

### Q3 — Films Released avec budget connu mais revenue manquant
```json
GET movies_clean/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "status": "Released" } }
      ],
      "must_not": [
        { "exists": { "field": "revenue" } }
      ],
      "filter": [
        { "exists": { "field": "budget" } }
      ]
    }
  },
  "size": 20
}
```
> **Métier** : Identifier les films dont on connaît l'investissement mais pas le retour — données incomplètes.

---

### Q4 — Films Horror ou Thriller sortis dans les années 90 bien votés
```json
GET movies_clean/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "terms": { "genres": ["Horror", "Thriller"] }
        }
      ],
      "filter": [
        { "range": { "release_date":  { "gte": "1990-01-01", "lte": "1999-12-31" } } },
        { "range": { "vote_average":  { "gte": 6.5 } } },
        { "range": { "vote_count":    { "gte": 200 } } }
      ],
      "must_not": [
        { "term": { "original_language": "xx" } }
      ]
    }
  },
  "sort": [{ "vote_average": "desc" }],
  "size": 10
}
```
> **Métier** : Classiques des années 90 en Horreur/Thriller pour une sélection éditoriale.

---

### Q5 — Recherche full-text avec filtres (moteur de recherche)
```json
GET movies_clean/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query":  "space adventure hero",
            "fields": ["title^3", "overview^2", "tagline", "keywords"],
            "type":   "best_fields",
            "fuzziness": "AUTO"
          }
        }
      ],
      "should": [
        { "range": { "vote_average": { "gte": 7.0, "boost": 1.5 } } },
        { "range": { "popularity":   { "gte": 50,  "boost": 1.2 } } }
      ],
      "filter": [
        { "term": { "status": "Released" } }
      ]
    }
  },
  "size": 10,
  "_source": ["title", "overview", "vote_average", "release_date", "genres"]
}
```
> **Métier** : Requête cœur du moteur de recherche, boost sur le titre, fuzziness pour les fautes de frappe.

---

## ── REQUÊTES ANALYTIQUES (7 supplémentaires) ──────────────

### Q6 — Top 10 films par popularité
```json
GET movies_clean/_search
{
  "query": { "match_all": {} },
  "sort":  [{ "popularity": { "order": "desc" } }],
  "size":  10,
  "_source": ["title", "popularity", "vote_average", "release_date", "genres"]
}
```
> **Métier** : Classement des films les plus populaires toutes périodes confondues.

---

### Q7 — Distribution des films par langue (agrégation)
```json
GET movies_clean/_search
{
  "size": 0,
  "aggs": {
    "by_language": {
      "terms": {
        "field": "original_language",
        "size":  20
      },
      "aggs": {
        "avg_rating": { "avg": { "field": "vote_average" } },
        "avg_popularity": { "avg": { "field": "popularity" } }
      }
    }
  }
}
```
> **Métier** : Répartition géolinguistique du catalogue + qualité perçue par langue.

---

### Q8 — Nombre de films par genre (agrégation)
```json
GET movies_clean/_search
{
  "size": 0,
  "aggs": {
    "by_genre": {
      "terms": {
        "field": "genres",
        "size":  30
      },
      "aggs": {
        "avg_vote":   { "avg":  { "field": "vote_average" } },
        "total_revenue": { "sum": { "field": "revenue" } }
      }
    }
  }
}
```
> **Métier** : Quel genre domine le catalogue ? Quel genre rapporte le plus ?

---

### Q9 — Évolution du nombre de sorties par année
```json
GET movies_clean/_search
{
  "size": 0,
  "aggs": {
    "by_year": {
      "date_histogram": {
        "field":             "release_date",
        "calendar_interval": "year",
        "format":            "yyyy"
      },
      "aggs": {
        "avg_rating":    { "avg": { "field": "vote_average" } },
        "avg_budget":    { "avg": { "field": "budget" } }
      }
    }
  }
}
```
> **Métier** : Tendance de production cinématographique sur plusieurs décennies.

---

### Q10 — Films avec le meilleur ROI (revenue/budget)
```json
GET movies_clean/_search
{
  "query": {
    "bool": {
      "filter": [
        { "exists": { "field": "budget" } },
        { "exists": { "field": "revenue" } },
        { "range": { "budget":  { "gte": 1000000 } } },
        { "range": { "revenue": { "gte": 1000000 } } }
      ]
    }
  },
  "script_fields": {
    "roi": {
      "script": {
        "source": "(doc['revenue'].value - doc['budget'].value) / doc['budget'].value * 100"
      }
    }
  },
  "sort": [{ "_script": { "type": "number", "script": { "source": "(doc['revenue'].value - doc['budget'].value) / doc['budget'].value" }, "order": "desc" } }],
  "size": 10,
  "_source": ["title", "budget", "revenue", "release_date"]
}
```
> **Métier** : Films les plus rentables en termes de retour sur investissement.

---

### Q11 — Qualité des données : films avec problèmes
```json
GET movies_clean/_search
{
  "size": 0,
  "aggs": {
    "issues_distribution": {
      "terms": {
        "field": "data_quality_issues",
        "size":  10
      }
    },
    "avg_quality_score": {
      "avg": { "field": "data_quality_score" }
    },
    "perfect_records": {
      "filter": {
        "term": { "data_quality_score": 100 }
      }
    }
  }
}
```
> **Métier** : Tableau de bord qualité des données — combien de films ont des données complètes ?

---

### Q12 — Stats globales du dataset (min, max, avg)
```json
GET movies_clean/_search
{
  "size": 0,
  "aggs": {
    "stats_vote_average": { "stats": { "field": "vote_average" } },
    "stats_popularity":   { "stats": { "field": "popularity" } },
    "stats_runtime":      { "stats": { "field": "runtime" } },
    "stats_budget":       { "stats": { "field": "budget" } },
    "stats_revenue":      { "stats": { "field": "revenue" } },
    "total_films":        { "value_count": { "field": "id" } }
  }
}
```
> **Métier** : Statistiques descriptives globales — vue d'ensemble du catalogue entier.
