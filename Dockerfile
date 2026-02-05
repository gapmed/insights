FROM ubuntu:22.04

# Evita prompt interattivi durante l'installazione
ENV DEBIAN_FRONTEND=noninteractive

# Installa dipendenze di base
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gdebi-core \
    && rm -rf /var/lib/apt/lists/*

# Scarica e installa Quarto (rileva automaticamente architettura)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ]; then \
        QUARTO_PKG="quarto-1.4.553-linux-arm64.deb"; \
    else \
        QUARTO_PKG="quarto-1.4.553-linux-amd64.deb"; \
    fi && \
    wget "https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.553/${QUARTO_PKG}" && \
    gdebi -n "${QUARTO_PKG}" && \
    rm "${QUARTO_PKG}"

WORKDIR /app

# Copia il progetto
COPY . .

# Build del sito statico
CMD ["quarto", "render"]
