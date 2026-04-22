# Dictionnaire de données — movies_clean

## Source
Kaggle — Millions of Movies Dataset (v67)
https://www.kaggle.com/datasets/akshaypawar7/millions-of-movies/versions/67

---

## Colonnes

| Champ | Type ES | Description | Valeurs possibles | % rempli (estimé) |
|---|---|---|---|---|
| `id` | `integer` | Identifiant unique TMDB | Entier positif | ~100 % |
| `title` | `text` + `keyword` | Titre du film | Texte libre | ~100 % |
| `genres` | `keyword[]` | Liste des genres | Action, Drama, Comedy... | ~99 % |
| `original_language` | `keyword` | Langue originale (code ISO 639-1) | en, fr, ja, ko... | ~100 % |
| `overview` | `text` | Synopsis du film | Texte libre | ~99 % |
| `popularity` | `float` | Score de popularité TMDB (calculé) | 0.0 – 10000+ | ~100 % |
| `production_companies` | `keyword[]` | Sociétés de production | Noms de studios | ~94 % |
| `release_date` | `date` | Date de sortie | Format `yyyy-MM-dd` | ~99 % |
| `budget` | `long` | Budget de production (USD) | 0 – 400 000 000 | ~35 % |
| `revenue` | `long` | Recettes au box-office (USD) | 0 – 3 000 000 000 | ~30 % |
| `runtime` | `integer` | Durée du film en minutes | 1 – 400+ | ~98 % |
| `status` | `keyword` | Statut de distribution | Released, Post Production... | ~100 % |
| `tagline` | `text` | Accroche marketing | Texte libre | ~69 % |
| `vote_average` | `float` | Note moyenne TMDB (0-10) | 0.0 – 10.0 | ~100 % |
| `vote_count` | `integer` | Nombre de votes TMDB | 0 – 40 000+ | ~100 % |
| `credits` | `keyword[]` | Liste des acteurs principaux | Noms d'acteurs | ~98 % |
| `keywords` | `keyword[]` | Mots-clés thématiques | Texte court | ~81 % |
| `poster_path` | `keyword` | Chemin relatif vers l'affiche TMDB | `/xxxx.jpg` | ~100 % |
| `backdrop_path` | `keyword` | Chemin relatif vers l'image de fond | `/xxxx.jpg` | ~97 % |
| `recommendations` | `keyword[]` | IDs de films recommandés | Liste d'entiers | ~91 % |
| `data_quality_issues` | `keyword[]` | Problèmes qualité détectés | `missing_budget`, `no_genres`... | Calculé |
| `data_quality_score` | `integer` | Score qualité 0-100 | 0 – 100 | Calculé |

---

## Valeurs du champ `status`

| Valeur | Description |
|---|---|
| `Released` | Film sorti en salle |
| `Post Production` | En post-production |
| `In Production` | En cours de tournage |
| `Planned` | Annoncé mais non tourné |
| `Rumored` | Rumeur non confirmée |
| `Canceled` | Production annulée |

---

## Genres possibles

Action, Adventure, Animation, Comedy, Crime, Documentary, Drama, Family,
Fantasy, History, Horror, Music, Mystery, Romance, Science Fiction,
Thriller, TV Movie, War, Western
