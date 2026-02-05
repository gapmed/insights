#!/bin/bash

# Script per build del sito statico con Docker
# Uso: ./build.sh

set -e

IMAGE_NAME="gapmed-insights-builder"
CONTAINER_NAME="gapmed-build"

echo "=== GAP Med Insights - Build con Docker (Quarto) ==="

# Pulizia cache
echo ">> Cleaning cache..."
rm -rf ./dist ./_site ./.quarto

# Build dell'immagine Docker
echo ">> Building Docker image..."
docker build -t $IMAGE_NAME .

# Rimuovi container precedente se esiste
docker rm -f $CONTAINER_NAME 2>/dev/null || true

# Esegui la build e copia l'output
echo ">> Running Quarto render..."
docker run --name $CONTAINER_NAME $IMAGE_NAME

# Copia la cartella dist dal container
echo ">> Copying dist folder..."
rm -rf ./dist
docker cp $CONTAINER_NAME:/app/dist ./dist

# Pulizia container
docker rm -f $CONTAINER_NAME

echo ""
echo "=== Build completata! ==="
echo ""
echo "Per visualizzare il sito in locale:"
echo "  ./serve.sh"
echo ""
echo "Oppure apri direttamente: dist/index.html"
