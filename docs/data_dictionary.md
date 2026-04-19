# Dictionnaire de données

## Objectif

Ce document décrit les principaux champs du dataset movies.csv ainsi que leur typage dans Elasticsearch après transformation dans l’index `movies_clean`.

---

## Description des champs

### id
- Description : identifiant unique du film
- Type source : numérique
- Type Elasticsearch : long
- Exemple :757658

### title
- Description : titre du film
- Type source : texte
- Type Elasticsearch : text (avec sous-champ keyword)
- Analyzer : movie_text_analyzer
- Exemple : Ex-Wife

### genres
- Description : genres du film
- Type source : texte
- Type Elasticsearch : keyword
- Exemple : Adventure-Crime-Drama

### original_language
- Description : langue originale du film
- Type source : texte
- Type Elasticsearch : keyword
- Exemple : en

### overview
- Description : résumé du film
- Type source : texte
- Type Elasticsearch : text
- Analyzer : movie_text_analyzer

### popularity
- Description : score de popularité du film
- Type source : numérique
- Type Elasticsearch : float

### production_companies
- Description : sociétés de production
- Type source : texte
- Type Elasticsearch : text
- Analyzer : movie_text_analyzer

### release_date
- Description : date de sortie du film
- Type source : texte (dans le CSV)
- Type Elasticsearch : date
- Exemple : 2020-10-25T00:00:00.000Z

### budget
- Description : budget du film
- Type source : numérique
- Type Elasticsearch : float

### revenue
- Description : revenus générés par le film
- Type source : numérique
- Type Elasticsearch : float

### runtime
- Description : durée du film en minutes
- Type source : numérique
- Type Elasticsearch : float

### status
- Description : statut du film (ex : Released)
- Type source : texte
- Type Elasticsearch : keyword

### tagline
- Description : slogan du film
- Type source : texte
- Type Elasticsearch : text
- Analyzer : movie_text_analyzer

### vote_average
- Description : note moyenne
- Type source : numérique
- Type Elasticsearch : float

### vote_count
- Description : nombre de votes
- Type source : numérique
- Type Elasticsearch : long

### credits
- Description : acteurs et contributeurs principaux
- Type source : texte
- Type Elasticsearch : text
- Analyzer : movie_text_analyzer

### keywords
- Description : mots-clés associés au film
- Type source : texte
- Type Elasticsearch : text
- Analyzer : movie_text_analyzer

### poster_path
- Description : chemin de l’affiche du film
- Type source : texte
- Type Elasticsearch : keyword

### backdrop_path
- Description : image de fond du film
- Type source : texte
- Type Elasticsearch : keyword

### recommendations
- Description : champ de recommandations (si présent)
- Type source : texte
- Type Elasticsearch : text
- Analyzer : movie_text_analyzer

---

## Remarques

- Un analyzer personnalisé `movie_text_analyzer` est utilisé pour plusieurs champs textuels afin d’améliorer la recherche full-text.
- Certains champs comme `genres`, `original_language` et `status` sont en `keyword` pour permettre des filtres et agrégations exactes.
- Les champs numériques ont été convertis pour permettre des analyses statistiques (moyenne, somme, etc.).
- Certains champs peuvent contenir des valeurs nulles en fonction de la qualité du dataset source.