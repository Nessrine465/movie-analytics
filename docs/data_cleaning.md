# Nettoyage des données

## Objectif

L’objectif de cette étape est de transformer les données brutes issues du fichier `movies.csv` en un index Elasticsearch propre et exploitable nommé `movies_clean`.

Le nettoyage est réalisé via un pipeline Logstash qui permet de parser, filtrer et typer les données avant leur indexation.

---

## Lecture du fichier source

Les données sont lues à partir du fichier CSV avec la configuration suivante :

- Lecture du fichier `/data/movies.csv`
- Lecture depuis le début (`start_position => "beginning"`)
- Désactivation du suivi (`sincedb_path => "/dev/null"`) pour relire le fichier à chaque exécution
- Mode lecture (`mode => "read"`)

Cela garantit une ingestion complète des données à chaque lancement du pipeline.

---

## Parsing du CSV

Le filtre `csv` permet de transformer chaque ligne du fichier en document structuré.

- Séparateur : `,`
- Ignorance de l’en-tête (`skip_header => true`)
- Mapping explicite des colonnes :

Champs extraits :
- id, title, genres, original_language, overview, popularity
- production_companies, release_date, budget, revenue, runtime
- status, tagline, vote_average, vote_count
- credits, keywords, poster_path, backdrop_path, recommendations

Cette étape permet de transformer les données brutes en champs exploitables dans Elasticsearch.

---

## Filtrage des données invalides

Une règle de filtrage est appliquée :

Les documents sans titre sont supprimés car ils ne sont pas exploitables :

- si `title` est vide ou null → suppression du document

Cela améliore la qualité globale de l’index.

---

## Conversion des types

Une transformation des types est appliquée avec `mutate` :

- `id` → integer (stocké en long dans Elasticsearch)
- `popularity` → float
- `budget` → float
- `revenue` → float
- `runtime` → float
- `vote_average` → float
- `vote_count` → integer (stocké en long dans Elasticsearch)

Cette étape est essentielle pour :
- permettre les agrégations
- garantir la cohérence des données
- améliorer les performances des requêtes

---

## Parsing des dates

Le champ `release_date` est converti en date avec le format :

yyyy-MM-dd

Le champ est ensuite stocké en type `date` dans Elasticsearch.

Cela permet :
- des filtres temporels
- des analyses par année
- l’utilisation dans Kibana

---

## Suppression des champs inutiles

Les champs techniques ajoutés automatiquement sont supprimés :

- message
- event
- host
- log
- @version

Ces champs ne sont pas utiles pour l’analyse métier.

---

## Indexation dans Elasticsearch

Les données nettoyées sont envoyées vers Elasticsearch :

- Index cible : `movies_clean`
- URL : http://elasticsearch:9200
- Identifiant du document : basé sur le champ `id`

L’utilisation d’un identifiant unique permet d’éviter les doublons.

---

## Résultat après nettoyage

Après transformation :

- Les données sont structurées
- Les types sont cohérents (float, date, long)
- Les documents incomplets sont supprimés
- L’index est prêt pour les requêtes analytiques et Kibana

---

## Impact avant / après

### Avant nettoyage
- Données brutes issues du CSV
- Types incorrects (principalement texte)
- Données incomplètes (titres manquants)
- Présence de champs techniques inutiles

### Après nettoyage
- Données typées correctement
- Documents invalides supprimés
- Données exploitables pour les analyses
- Index optimisé pour Elasticsearch

---

## Limites

- Les champs de type liste (`genres`, `keywords`, `credits`) ne sont pas normalisés en tableaux
- Certaines valeurs restent nulles
- Aucun enrichissement des données n’a été effectué

---

## Conclusion

Le pipeline Logstash permet de transformer efficacement les données brutes en un index structuré et exploitable.

Ce nettoyage constitue une étape essentielle pour garantir la qualité des données et permettre leur exploitation dans Elasticsearch et Kibana.