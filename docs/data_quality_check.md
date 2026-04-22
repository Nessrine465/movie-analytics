# Contrôle qualité des données

## Objectif
Vérifier que les données dans l’index `movies_clean` sont correctement nettoyées et structurées après ingestion.

---

## 1. Vérification du nombre de documents

```json    
GET movies_raw/_count
GET movies_clean/_count
```
- Résultat attendu :
    1. movies_clean doit contenir des données (count > 0)
    2. le nombre peut être légèrement inférieur à movies_raw (suppression des lignes invalides)

## 2. Vérification du mapping

```json 
GET movies_clean/_mapping
```
- Points vérifiés :
    - présence des types explicites (integer, float, date, keyword, text)
    - présence de l’analyzer personnalisé custom_text_analyzer

## 3. Vérification d’un échantillon

```json 
GET movies_clean/_search
{
  "size": 5,
  "_source": [
    "id",
    "title",
    "release_date",
    "budget",
    "revenue",
    "runtime",
    "vote_average",
    "vote_count"
  ]
}
```
- Points vérifiés :   
   - les champs numériques sont bien convertis
   - les dates sont correctement parsées
   - les champs texte sont propres (pas vides)

## 4. Comparaison avant / après

- movies_raw : données brutes issues du CSV
- movies_clean : données nettoyées et typées
- suppression des lignes sans titre
- amélioration de la qualité globale des données

## Conclusion

L’index `movies_clean` contient des données nettoyées, typées et prêtes pour l’analyse dans Elasticsearch et Kibana.
