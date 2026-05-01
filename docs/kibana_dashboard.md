# Dashboard Kibana

## Objectif

L’objectif de cette étape est de créer un dashboard Kibana permettant d’analyser visuellement les données de l’index `movies_clean`.

Ce dashboard permet d’explorer les données du dataset films à travers plusieurs visualisations complémentaires, afin de faciliter la compréhension globale des tendances.

---

## Source de données

Le dashboard repose sur l’index Elasticsearch :

- `movies_clean`

Cet index contient les données nettoyées et enrichies via le pipeline Logstash.

---

## Structure du dashboard

Le dashboard est organisé en plusieurs visualisations couvrant différents aspects :

- analyse par langue
- analyse temporelle
- analyse par genre
- analyse des revenus
- analyse des notes
- analyse du statut des films
- analyse des films les mieux notés

Chaque visualisation contient également une description directement dans Kibana pour faciliter la lecture.

---

## Visualisations réalisées

### 1. Nombre de films par langue

Cette visualisation présente le nombre de films par langue originale.

**Intérêt :**
- identifier les langues dominantes
- comprendre la répartition du dataset

---

### 2. Moyenne des notes par langue

Cette visualisation montre la note moyenne (`vote_average`) par langue.

**Intérêt :**
- comparer la qualité moyenne des films selon la langue
- identifier des tendances éventuelles

---

### 3. Évolution du nombre de films par année

Cette visualisation représente le nombre de films produits au fil des années.

**Intérêt :**
- observer l’évolution de la production
- identifier les périodes de forte croissance

---

### 4. Évolution des revenus du cinéma par année

Cette visualisation montre les revenus totaux (`revenue`) par année.

**Intérêt :**
- analyser la croissance économique du cinéma
- observer les tendances globales de revenus

---

### 5. Répartition des films par genre

Cette visualisation met en avant les genres les plus présents dans le dataset.

**Intérêt :**
- comprendre les types de contenus dominants
- identifier les genres les plus populaires

---

### 6. Répartition des films par statut

Cette visualisation présente les différents statuts des films (Released, Planned, etc.).

**Intérêt :**
- vérifier la cohérence des données
- observer la distribution des statuts

---

### 7. Revenus moyens selon le budget des films

Cette visualisation met en relation le budget et les revenus.

**Intérêt :**
- analyser la rentabilité globale
- observer l’impact du budget sur les revenus

---

### 8. Top 10 des films les mieux notés (avec plus de 100 votes)

Cette visualisation affiche les films ayant les meilleures notes avec un minimum de votes.

**Intérêt :**
- éviter les biais liés aux films avec peu de votes
- identifier les films les mieux évalués

---

## Lecture globale du dashboard

Le dashboard permet de dégager plusieurs observations :

- la majorité des films est en langue anglaise
- la production de films augmente fortement au fil du temps
- certains genres dominent largement le dataset
- les revenus du cinéma montrent une forte croissance sur les années récentes
- la relation budget / revenus met en évidence des écarts importants
- les films les mieux notés peuvent être identifiés facilement grâce au filtre sur le nombre de votes

Ce dashboard permet donc une analyse rapide et visuelle sans passer uniquement par des requêtes Elasticsearch.

---

## Export du dashboard

Le dashboard et les visualisations ont été exportés depuis Kibana au format :

- `.ndjson`

Le fichier exporté du dashboard est : `Kibana/export/movies_dashboard.ndjson`

Ce fichier permet de reproduire facilement le dashboard sur une autre instance Kibana.

---

## Import dans Kibana

Pour importer le dashboard :

1. lancer la stack ELK
2. vérifier que l’index `movies_clean` est présent
3. ouvrir Kibana (`http://localhost:5601`)
4. aller dans **Stack Management**
5. ouvrir **Saved Objects**
6. cliquer sur **Import**
7. sélectionner le fichier `.ndjson`
8. valider l’import

---

## Remarques

- Le dashboard dépend directement de la qualité des données dans `movies_clean`
- Certaines visualisations peuvent être enrichies avec des filtres ou des agrégations supplémentaires
- Les descriptions ajoutées dans Kibana facilitent l’interprétation des graphiques
- Ce dashboard nécessite que l’index `movies_clean` soit préalablement créé.
- Les étapes complètes d’installation et d’ingestion des données sont décrites dans le fichier `runbook.md`.

---

## Conclusion

La mise en place du dashboard Kibana permet d’apporter une lecture visuelle claire et synthétique des données.

Cette étape complète le travail réalisé sur Elasticsearch en rendant les résultats accessibles et exploitables rapidement.