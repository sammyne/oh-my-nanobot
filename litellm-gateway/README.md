# LiteLLM 网关负载均衡版个人 nanobot

结余 LiteLLM 网关实现 LLM 服务的负载均衡，便于利用多个产商的 LLM 服务。


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
- `agents.default.model` 设置为 static/litellm.yaml 中 `model_list` 列表的任意一个 `model_name`
- `agents.default.provider` 设置为 `custom`
- 【可选】`channel` 开启一种通道

#### 2.3.2. .env
添加如下配置项

配置项 | 说明
------|-----------
`MODELSCOPE_API_KEY` | 从 [魔塔社区](https://modelscope.cn/models) 获取到的 `API_KEY`
`NVIDIA_API_KEY` | 从 [英伟达官网](https://build.nvidia.com/models) 获取到的 `API_KEY`
`TAVILY_API_KEY` | tavily 搜索服务依赖的 API Key，从 https://app.tavily.com/home 申请即可

### 2.4. 启动网关

```bash
docker compose up -d nanobot-gateway
```

## 3. 文件说明
- Dockerfile 和 docker-compose.yml 基于 HKUDS/nanobot@v0.1.4.post2 的副本改造得到

## 4. 参考文献
- https://github.com/HKUDS/nanobot
