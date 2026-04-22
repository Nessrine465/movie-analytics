#!/bin/bash
# stop.sh — Arrêt propre de la stack ELK

echo "🛑 Arrêt de la stack ELK..."
docker-compose down
echo "✅ Stack arrêtée."
