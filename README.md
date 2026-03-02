# 个人定制版 nanobot

<p align="center">
  <!-- Keep these links. Translations will automatically update with the README. -->
  <a href="https://github.com/sammyne/oh-my-nanobot">中文</a> |
  <a href="https://www.readme-i18n.com/sammyne/oh-my-nanobot?lang=en">English</a>
</p>

此项目是基于 [HKUDS/nanobot](https://github.com/HKUDS/nanobot) 的个人定制版本，主要拓展
增加了基于 [Tavily 搜索](https://github.com/tavily-ai/skills/tree/main/skills/tavily/search) 的内置技能。

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

#### 2.3.1. .nanobot/config.json

根据需要更新配置项，重点关注
- `agents.default.model`
- 【可选】`channel` 开启一种通道
- `providers` 提供 LLM 服务依赖的配置

#### 2.3.2. .env
添加如下配置项

配置项 | 说明
------|-----------
`TAVILY_API_KEY` | tavily 搜索服务依赖的 API Key，从 https://app.tavily.com/home 申请即可

### 2.4. 启动网关

```bash
docker compose up -d nanobot-gateway
```

后续通过配置的通道即可与 nanobot 交互。

## 3. 文件说明
- Dockerfile 和 docker-compose.yml 基于 HKUDS/nanobot@v0.1.4.post2 的副本改造得到
- litellm-gateway 是借助 LiteLLM 网关负载均衡 LLM 服务的版本

## 4. 参考文献
- https://github.com/HKUDS/nanobot
