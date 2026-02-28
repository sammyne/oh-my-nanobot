FROM busybox:1.37.0-glibc AS repo

ARG REV=v0.1.4.post2

WORKDIR /nanobot

RUN wget https://github.com/HKUDS/nanobot/archive/$REV.tar.gz -O nanobot.tar.gz

RUN tar -xzf nanobot.tar.gz --strip-components=1 && rm nanobot.tar.gz


FROM busybox:1.37.0-glibc AS skills

ARG TAVILY_REV=f63aeef

WORKDIR /output/tavily-search

RUN wget https://github.com/tavily-ai/skills/archive/$TAVILY_REV.tar.gz -O /tmp/tavily-skills.tgz

RUN mkdir -p /tmp/tavily-skills && tar -xzf /tmp/tavily-skills.tgz --strip-components=1 -C /tmp/tavily-skills

RUN mv /tmp/tavily-skills/skills/tavily/search/* .


FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Use Aliyun PyPI mirror for faster package downloads
ENV UV_INDEX_URL=https://mirrors.aliyun.com/pypi/simple/

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

# 添加为 nanobot 的内置技能
COPY --from=skills /output nanobot/skills

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
