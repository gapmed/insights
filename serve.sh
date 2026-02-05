#!/bin/bash

# Script per servire il sito statico in locale con Docker
# Uso: ./serve.sh [porta]

set -e

PORT=${1:-8000}

if [ ! -d "./docs" ]; then
    echo "Errore: cartella docs/ non trovata."
    echo "Esegui prima ./build.sh per generare il sito."
    exit 1
fi

echo "=== GAP Med Insights - Server locale ==="
echo "Serving su http://localhost:$PORT"
echo "Premi Ctrl+C per fermare"
echo ""

docker run --rm -p $PORT:80 \
    -v "$(pwd)/docs:/usr/share/nginx/html:ro" \
    -v "$(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro" \
    nginx:alpine
