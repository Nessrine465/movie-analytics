# Script de Démonstration — Movies Data Platform

## Parcours de démo (correspondant au demo.gif)

---

### Étape 1 — Démarrage de la stack
```bash
./start.sh
```
> Montrer les logs de démarrage, la confirmation d'Elasticsearch et Kibana prêts.

---

### Étape 2 — Vérification de l'ingestion
```bash
./health.sh
```
> Montrer le nombre de documents dans `movies_raw` et `movies_clean`.

```bash
curl "http://localhost:9200/movies_clean/_search?size=1&pretty"
```
> Montrer un document nettoyé avec genres en array, date parsée, etc.

---

### Étape 3 — Requête Elasticsearch (dans Kibana Dev Tools)
Coller et exécuter :
```json
GET movies_clean/_search
{
  "query": {
    "bool": {
      "must": [{ "term": { "original_language": "en" } }],
      "filter": [
        { "range": { "vote_average": { "gte": 8.0 } } },
        { "range": { "vote_count": { "gte": 1000 } } }
      ]
    }
  },
  "sort": [{ "vote_average": "desc" }],
  "size": 5
}
```
> Montrer les 5 meilleurs films anglais avec note ≥ 8.

---

### Étape 4 — Dashboard Kibana
1. Ouvrir **Dashboard → Movies Analytics Dashboard**
2. Parcourir les visualisations :
   - Nombre de films par genre
   - Évolution des sorties par année
   - Top 10 popularité
   - Note moyenne par langue

---

### Étape 5 — Moteur de recherche
1. Ouvrir `search-engine/index.html` dans un navigateur
2. Rechercher **"space adventure"**
3. Filtrer par langue **Anglais**
4. Filtrer par genre **Science Fiction**
5. Montrer les résultats avec affiches et notes

---

## Durée totale de la démo : ~2-3 minutes
