FROM busybox:1.37.0-glibc AS repo

ARG REV=v0.1.4.post2

WORKDIR /nanobot

RUN wget https://github.com/HKUDS/nanobot/archive/$REV.tar.gz -O nanobot.tar.gz

RUN tar -xzf nanobot.tar.gz --strip-components=1 && rm nanobot.tar.gz


FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

RUN sed -i 's/deb.debian.org/mirrors.tencent.com/g' /etc/apt/sources.list.d/debian.sources &&\
    sed -i 's|security.debian.org/debian-security|mirrors.tencent.com/debian-security|g' /etc/apt/sources.list.d/debian.sources

# Install Node.js 20 for the WhatsApp bridge
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates gnupg git && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get purge -y gnupg && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies first (cached layer)
COPY --from=repo /nanobot/pyproject.toml /nanobot/README.md /nanobot/LICENSE ./
RUN mkdir -p nanobot bridge && touch nanobot/__init__.py && \
    uv pip install --system --no-cache . && \
    rm -rf nanobot bridge

# Copy the full source and install
COPY --from=repo /nanobot/nanobot/ nanobot/
COPY --from=repo /nanobot/bridge/ bridge/
RUN uv pip install --system --no-cache .

# Build the WhatsApp bridge
WORKDIR /app/bridge
RUN npm install && npm run build
WORKDIR /app

# Create config directory
RUN mkdir -p /root/.nanobot

# Gateway default port
EXPOSE 18790

ENTRYPOINT ["nanobot"]
CMD ["status"]
