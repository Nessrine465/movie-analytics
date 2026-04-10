# Documentation du Nettoyage des Données
## Movies Data Platform — ELK Stack

---

## 1. Source des données

- **Fichier** : `movies.csv`
- **Origine** : Kaggle — Millions of Movies Dataset
- **Taille brute** : ~373 MB
- **Nombre de lignes** : ~769 631 films
- **Nombre de colonnes** : 20

---

## 2. Anomalies détectées

### 2.1 Problèmes de types
| Colonne | Problème | Règle appliquée |
|---|---|---|
| `budget` | Float au lieu de Long, contient des `0.0` | Cast en long, suppression si ≤ 0 |
| `revenue` | Float au lieu de Long, contient des `0.0` | Cast en long, suppression si ≤ 0 |
| `runtime` | Float (`137.0`) au lieu d'Integer | Cast float → integer |
| `vote_count` | Float au lieu d'Integer | Cast en integer |
| `release_date` | String `"yyyy-MM-dd"` | Parsing via filter `date{}` |
| `vote_average` | Parfois hors borne [0-10] | Suppression si invalide |

### 2.2 Valeurs manquantes (estimation sur échantillon de 1000 lignes)
| Colonne | % manquant | Traitement |
|---|---|---|
| `tagline` | ~31 % | Suppression du champ si vide |
| `keywords` | ~19 % | Remplacement par tableau vide `[]` |
| `recommendations` | ~9 % | Remplacement par tableau vide `[]` |
| `production_companies` | ~6 % | Remplacement par tableau vide `[]` |
| `backdrop_path` | ~3 % | Conservé tel quel (non indexé) |
| `overview` | ~0.9 % | Suppression du champ si vide |
| `release_date` | ~0.8 % | Suppression du champ si vide |

### 2.3 Champs liste mal formatés
Les champs `genres`, `credits`, `keywords`, `production_companies` et `recommendations` utilisent le séparateur `-` (et non JSON) :

```
Genres bruts   : "Action-Adventure-Fantasy"
Crédits bruts  : "Alexander Skarsgård-Nicole Kidman-Claes Bang"
Keywords bruts : "sword-father murder-prince-iceland"
```

---

## 3. Règles de nettoyage appliquées (Logstash)

### Conversions de types
```ruby
mutate {
  convert => {
    "popularity"    => "float"
    "budget"        => "float"
    "revenue"       => "float"
    "runtime"       => "float"
    "vote_average"  => "float"
    "vote_count"    => "float"
    "id"            => "integer"
  }
}
```

### Parsing de la date
```ruby
date {
  match  => ["release_date", "yyyy-MM-dd"]
  target => "release_date"
}
```

### Normalisation des listes
```ruby
mutate { split => { "genres" => "-" } }
ruby { code => 'event.set("genres", event.get("genres").map(&:strip).reject(&:empty?))' }
```

### Suppression des valeurs invalides
```ruby
if [budget]  and [budget]  <= 0 { mutate { remove_field => ["budget"]  } }
if [revenue] and [revenue] <= 0 { mutate { remove_field => ["revenue"] } }
if [runtime] and [runtime] <= 0 { mutate { remove_field => ["runtime"] } }
```

---

## 4. Mesure d'impact avant / après nettoyage

| Métrique | movies_raw | movies_clean | Différence |
|---|---|---|---|
| Documents | ~769 631 | ~769 631 | 0 (aucun film supprimé) |
| Champ `budget` présent | ~100 % | ~35 % | -65 % (budgets à 0 supprimés) |
| Champ `revenue` présent | ~100 % | ~30 % | -70 % (revenus à 0 supprimés) |
| Type `release_date` | string | date ISO | ✅ requêtes range possibles |
| Type `genres` | string | keyword[] | ✅ agrégations par genre |
| Type `credits` | string | keyword[] | ✅ recherche par acteur |
| `data_quality_score` moyen | n/a | ~60/100 | Score calculé automatiquement |

---

## 5. Score qualité ajouté

Chaque document `movies_clean` contient deux champs supplémentaires :

- `data_quality_issues` : liste des problèmes détectés (ex: `["missing_budget", "missing_revenue"]`)
- `data_quality_score` : entier de 0 à 100 (100 = données complètes)

Formule : `100 - (nombre_de_problèmes × 10)`
