# Guide de création du Dashboard Kibana
## Movies Data Platform

Suivre ces étapes dans Kibana → **Analytics → Dashboard → Create dashboard**

---

## Pré-requis : Créer la Data View

1. Aller dans **Stack Management → Data Views**
2. Cliquer **Create data view**
3. Name : `Movies Clean`
4. Index pattern : `movies_clean`
5. Timestamp field : `release_date`
6. Sauvegarder

---

## Visualisation 1 — Nombre de films par genre (Bar chart)

**Type** : Bar vertical

1. Cliquer **Create visualization** → **Bar vertical**
2. Data view : `movies_clean`
3. **Horizontal axis** : `Top values of genres` (Terms, size 15)
4. **Vertical axis** : `Count of records`
5. Title : `📊 Films par genre`
6. Sauvegarder

---

## Visualisation 2 — Évolution des sorties par année (Line chart)

**Type** : Line

1. **Horizontal axis** : `release_date` → Date histogram → `Year`
2. **Vertical axis** : `Count of records`
3. Title : `📅 Évolution des sorties cinéma par année`
4. Sauvegarder

---

## Visualisation 3 — Note moyenne par genre (Bar horizontal)

**Type** : Bar horizontal

1. **Vertical axis** : `Top values of genres` (Terms, size 15)
2. **Horizontal axis** : `Average of vote_average`
3. Title : `⭐ Note moyenne par genre`
4. Sauvegarder

---

## Visualisation 4 — Répartition par langue (Pie chart)

**Type** : Pie

1. **Slice by** : `Top values of original_language` (Terms, size 10)
2. **Size** : `Count of records`
3. Title : `🌍 Répartition par langue originale`
4. Sauvegarder

---

## Visualisation 5 — Top 10 films par popularité (Data table)

**Type** : Table

1. **Rows** : `Top values of title.keyword` (Terms, size 10, order by `Max of popularity`)
2. **Metrics** :
   - `Max of popularity`
   - `Max of vote_average`
3. Title : `🔥 Top 10 films les plus populaires`
4. Sauvegarder

---

## Visualisation 6 — Score qualité des données (Metric)

**Type** : Metric

1. **Primary metric** : `Average of data_quality_score`
2. Ajouter une **secondary metric** : `Count of records`
3. Title : `✅ Score qualité moyen des données`
4. Sauvegarder

---

## Visualisation 7 — Budget moyen par genre (Bar vertical)

**Type** : Bar vertical

1. **Horizontal axis** : `Top values of genres` (Terms, size 10, order by `Average of budget`)
2. **Vertical axis** : `Average of budget`
3. Title : `💰 Budget moyen par genre (USD)`
4. Sauvegarder

---

## Visualisation 8 — Distribution des notes (Histogram)

**Type** : Bar vertical

1. **Horizontal axis** : `vote_average` → Histogram, interval `0.5`
2. **Vertical axis** : `Count of records`
3. Title : `📈 Distribution des notes (vote_average)`
4. Sauvegarder

---

## Assemblage du Dashboard

1. Aller dans **Dashboard → Create dashboard**
2. Cliquer **Add from library**
3. Ajouter les 8 visualisations
4. Organiser en grille :
   ```
   [V1 - Genres]        [V2 - Évolution années]
   [V3 - Notes/genre]   [V4 - Langues]
   [V5 - Top 10]        [V6 - Score qualité]
   [V7 - Budget]        [V8 - Distribution notes]
   ```
5. Title du dashboard : `🎬 Movies Analytics Dashboard`
6. Sauvegarder

---

## Export du dashboard

**Stack Management → Saved Objects → Cocher le dashboard → Export**

Sauvegarder le fichier sous `docs/kibana_export.ndjson`
