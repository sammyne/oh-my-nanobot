# 个人定制版 nanobot

## 1. 环境
- docker 24.0.6, build ed223bc
- docker-compose v2.21.0

## 2. 快速开始

### 2.1. 构建镜像

```bash
bash dockerize.sh
```

### 2.2. 生成配置模板

```bash
docker compose run --rm nanobot-cli onboard
```

### 2.3. 调整配置

根据需要更新 .nanobot/config.json 的配置项，重点关注
- `agents.default.model`
- 【可选】`channel` 开启一种通道
- `providers` 提供截图 LLM 服务依赖的配置

### 2.4. 启动网关

```bash
docker compose up -d nanobot-gateway
```

## 3. 文件说明
- Dockerfile 和 docker-compose.yml 基于 HKUDS/nanobot@v0.1.4.post2 的副本改造得到

## 4. 参考文献
- https://github.com/HKUDS/nanobot
