#!/bin/bash
# ─────────────────────────────────────────────
# start.sh — Démarrage de la stack ELK Movies
# ─────────────────────────────────────────────

set -e

echo "🚀 Démarrage de la stack ELK..."
docker-compose up -d elasticsearch kibana

echo "⏳ Attente d'Elasticsearch..."
until curl -s http://localhost:9200/_cluster/health | grep -q '"status":"green"\|"status":"yellow"'; do
  sleep 3
  echo "   ...en attente"
done
echo "✅ Elasticsearch prêt !"

echo "⏳ Attente de Kibana..."
until curl -s http://localhost:5601/api/status | grep -q '"level":"available"'; do
  sleep 5
  echo "   ...en attente"
done
echo "✅ Kibana prêt !"

echo ""
echo "📐 Création du mapping movies_clean..."
curl -s -X DELETE "http://localhost:9200/movies_clean" > /dev/null 2>&1 || true
curl -s -X PUT "http://localhost:9200/movies_clean" \
  -H 'Content-Type: application/json' \
  -d @elasticsearch/mapping_movies_clean.json | python3 -m json.tool
echo "✅ Mapping créé !"

echo ""
echo "🔄 Démarrage de Logstash (ingestion)..."
docker-compose up -d logstash

echo ""
echo "════════════════════════════════════════"
echo "  Stack ELK opérationnelle !"
echo "  Elasticsearch : http://localhost:9200"
echo "  Kibana         : http://localhost:5601"
echo "════════════════════════════════════════"
