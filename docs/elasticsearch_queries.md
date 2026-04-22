# Requêtes Elasticsearch — movies_clean

Ce fichier contient les principales requêtes Elasticsearch utilisées sur l’index `movies_clean`.

## 1. Compter le nombre de documents
Permet de connaître le nombre total de films dans l’index nettoyé.

```json
GET movies_clean/_count 
```
## 2. Afficher un échantillon de documents
Affiche quelques documents pour vérifier la structure des données.  

```json
GET movies_clean/_search
{
  "size": 5,
  "_source": [
    "id",
    "title",
    "release_date",
    "genres",
    "original_language",
    "popularity"
  ]
}
```
## 3. Top 10 des films les plus populaires
Retourne les 10 films ayant la plus grande popularité.

```json
GET movies_clean/_search
{
  "size": 10,
  "sort": [
    { "popularity": "desc" }
  ],
  "_source": [
    "title",
    "popularity",
    "release_date",
    "original_language"
  ]
}
```
## 4. Films les mieux notés avec au moins 100 votes
Permet d’éviter les films peu notés avec peu de votes.

```json
GET movies_clean/_search
{
  "size": 10,
  "query": {
    "range": {
      "vote_count": {
        "gte": 100
      }
    }
  },
  "sort": [
    { "vote_average": "desc" }
  ],
  "_source": [
    "title",
    "vote_average",
    "vote_count",
    "release_date"
  ]
}
```
## 5. Films en anglais sortis après 2015
Filtre les films en anglais sortis après 2015.

```json
GET movies_clean/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [
        { "term": { "original_language": "en" } },
        {
          "range": {
            "release_date": {
              "gte": "2015-01-01"
            }
          }
        }
      ]
    }
  },
  "_source": [
    "title",
    "release_date",
    "original_language"
  ]
}
```
## 6. Films sortis après 2010 avec popularité >= 1
Permet de récupérer des films récents avec une popularité minimale.

```json
GET movies_clean/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "release_date": {
              "gte": "2010-01-01"
            }
          }
        },
        {
          "range": {
            "popularity": {
              "gte": 1
            }
          }
        }
      ]
    }
  },
  "_source": [
    "title",
    "release_date",
    "popularity",
    "status"
  ],
  "sort": [
    {
      "popularity": "desc"
    }
  ]
}
```
## 7. Films documentaires ou historiques en français ou anglais
Recherche des films selon la langue et le genre.

```json
GET movies_clean/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [
        {
          "terms": {
            "original_language": ["en", "fr"]
          }
        }
      ],
      "should": [
        { "wildcard": { "genres": "*Documentary*" } },
        { "wildcard": { "genres": "*History*" } }
      ],
      "minimum_should_match": 1
    }
  },
  "_source": [
    "title",
    "genres",
    "original_language"
  ]
}
```
## 8. Films avec overview présent mais sans tagline
Permet d’identifier des données incomplètes.

```json
GET movies_clean/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [
        { "exists": { "field": "overview" } }
      ],
      "must_not": [
        { "exists": { "field": "tagline" } }
      ]
    }
  },
  "_source": [
    "title",
    "overview",
    "tagline"
  ]
}
```
## 9. Films avec budget > 1 000 000 et revenue = 0
Permet de détecter des anomalies dans les données financières.

```json
GET movies_clean/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "budget": {
              "gt": 1000000
            }
          }
        },
        {
          "term": {
            "revenue": 0
          }
        }
      ]
    }
  },
  "_source": [
    "title",
    "budget",
    "revenue",
    "release_date"
  ]
}
```

## 10. Top des langues
Permet de voir les langues les plus présentes dans le dataset.

```json
GET movies_clean/_search
{
  "size": 0,
  "aggs": {
    "top_languages": {
      "terms": {
        "field": "original_language",
        "size": 10
      }
    }
  }
}
```
## 11. Nombre de films par statut
Permet de visualiser la répartition des films selon leur statut.

```json
GET movies_clean/_search
{
  "size": 0,
  "aggs": {
    "by_status": {
      "terms": {
        "field": "status",
        "size": 10
      }
    }
  }
}
```
## 12. Moyenne des notes par langue
Permet d’analyser la qualité moyenne des films selon la langue.

```json
GET movies_clean/_search
{
  "size": 0,
  "aggs": {
    "languages": {
      "terms": {
        "field": "original_language",
        "size": 10
      },
      "aggs": {
        "avg_rating": {
          "avg": {
            "field": "vote_average"
          }
        }
      }
    }
  }
}
```
## Conclusion

Ces requêtes permettent d’explorer, filtrer et analyser les données de l’index `movies_clean`.  
Elles couvrent des cas simples de recherche, des filtres booléens et des agrégations utiles pour l’analyse dans Elasticsearch et Kibana.