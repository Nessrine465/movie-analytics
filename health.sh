#!/bin/bash
# health.sh — Vérification de l'état de la stack

echo "═══════════════════════════════════════"
echo "  HEALTH CHECK — ELK Movies Stack"
echo "═══════════════════════════════════════"

# Elasticsearch
echo ""
echo "📌 Elasticsearch (http://localhost:9200)"
ES_STATUS=$(curl -s http://localhost:9200/_cluster/health | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('status','unreachable'))" 2>/dev/null || echo "unreachable")
echo "   Status cluster : $ES_STATUS"

# Nombre de docs dans movies_raw
RAW_COUNT=$(curl -s http://localhost:9200/movies_raw/_count 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('count', 0))" 2>/dev/null || echo "index absent")
echo "   movies_raw     : $RAW_COUNT documents"

# Nombre de docs dans movies_clean
CLEAN_COUNT=$(curl -s http://localhost:9200/movies_clean/_count 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('count', 0))" 2>/dev/null || echo "index absent")
echo "   movies_clean   : $CLEAN_COUNT documents"

# Kibana
echo ""
echo "📌 Kibana (http://localhost:5601)"
KIBANA_STATUS=$(curl -s http://localhost:5601/api/status | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('status',{}).get('overall',{}).get('level','unreachable'))" 2>/dev/null || echo "unreachable")
echo "   Status : $KIBANA_STATUS"

# Logstash
echo ""
echo "📌 Logstash"
LOGSTASH_STATUS=$(docker inspect --format='{{.State.Status}}' logstash 2>/dev/null || echo "conteneur absent")
echo "   Status : $LOGSTASH_STATUS"

echo ""
echo "═══════════════════════════════════════"
