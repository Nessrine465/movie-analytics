# Gestion de Projet — Movies Data Platform

## Organisation de l'équipe

| Rôle | Membre | Responsabilités |
|---|---|---|
| Lead Technique | Membre 1 | Architecture, docker-compose, coordination, documentation |
| Dev Backend | Membre 2 | Ingestion Logstash, moteur de recherche |
| Dev Data | Membre 3 | Nettoyage, mapping, qualité des données |
| Dev Analytics | Membre 4 | Requêtes DSL, dashboard Kibana |

---

## Gitflow

```
main         ← version stable uniquement (PR obligatoire depuis dev)
└── dev      ← intégration (PR obligatoire depuis features)
    ├── feature/F1-bootstrap-stack
    ├── feature/F2-ingestion-brute
    ├── feature/F3-nettoyage
    ├── feature/F4-mapping
    ├── feature/F5-requetes
    ├── feature/F6-kibana
    ├── feature/F7-documentation
    └── feature/F8-moteur-recherche
```

### Règles
- ❌ Aucun push direct sur `main` ou `dev`
- ✅ PR obligatoire pour tout merge
- ✅ Minimum 1 reviewer par PR
- ✅ Commits explicites : `feat:`, `fix:`, `docs:`, `chore:`

---

## Exemple de commits attendus

```
feat(F2): add logstash pipeline for movies_raw ingestion
fix(F3): handle empty genres field in split filter
docs(F7): add data_cleaning.md with before/after metrics
chore(F1): add health check script
```

---

## Checklist de validation finale

- [ ] `docker-compose up` démarre sans erreur
- [ ] `movies_raw` contient ~769 631 documents
- [ ] `movies_clean` contient ~769 631 documents
- [ ] Le mapping `movies_clean` est explicite (types corrects)
- [ ] L'analyzer `movie_analyzer` fonctionne
- [ ] 12 requêtes DSL documentées dans `docs/queries.md`
- [ ] Dashboard Kibana avec 6+ visualisations
- [ ] Moteur de recherche `search-engine/index.html` fonctionnel
- [ ] `docs/planning_poker.md` complété
- [ ] `docs/data_dictionary.md` complété
- [ ] `docs/data_cleaning.md` avec mesures avant/après
- [ ] `docs/runbook.md` exécutable sur machine vierge
- [ ] `docs/demo_script.md` présent
- [ ] `docs/demo.gif` présent
- [ ] Toutes les PR sont traçables sur GitHub
