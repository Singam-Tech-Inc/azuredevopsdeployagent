# Azure DevOps Agent + Traefik Canary Demo

Reusable Docker Compose template for:

1. Running a self-hosted Azure DevOps deployment agent in a container
2. Hosting three sample apps behind Traefik with path-based routing
3. Performing weighted canary rollouts for app1

## What This Project Provides

1. Path-based routing on a single local endpoint:
	- http://localhost:3000/app1/
	- http://localhost:3000/app2/
	- http://localhost:3000/app3/
2. Weighted canary deployment for app1 via Traefik dynamic config
3. Health checks for all services
4. Security hardening defaults:
	- non-root app runtime
	- no-new-privileges
	- read-only root filesystem for app containers
	- tmpfs mount for ephemeral writes
5. Reusable network/volume defaults (no external network prerequisite)
6. Optional Azure DevOps agent profile so app stack can run independently

## Repository Layout

1. docker-compose.yml: main service definitions
2. traefik/conf/dynamic.yml: path routing and canary weights
3. webapp/: shared Node Dockerfile and sample apps
4. deployagent.sh: Azure DevOps agent bootstrap
5. build_push_up.sh: multi-arch agent image build helper
6. check_canary_split.sh: traffic split verification script

## Prerequisites

1. Docker Desktop (or Docker Engine + Compose v2)
2. macOS/Linux shell with curl and bash

## Quick Start

1. Create env file:

```bash
cp .env.example .env
```

2. Start app stack (Traefik + app1/app2/app3):

```bash
docker compose up -d --scale app1=3 --scale app1-canary=2 traefik app1 app1-canary app2 app3
```

3. Verify routes:

```bash
curl -I http://127.0.0.1:3000/
curl http://127.0.0.1:3000/app2/health
```

4. Check canary split:

```bash
bash check_canary_split.sh localhost 200 http://127.0.0.1:3000/app1/
```

## Canary Rollout Operations

Edit traefik/conf/dynamic.yml:

1. 90/10 rollout:
	- app1 weight: 9
	- app1-canary weight: 1
2. 50/50 testing:
	- app1 weight: 5
	- app1-canary weight: 5
3. Full canary promotion:
	- app1 weight: 0
	- app1-canary weight: 10

Traefik auto-reloads file changes. No container restart is required for weight changes.

## Azure DevOps Agent Usage

Agent service is under profile agent.

1. Run only agent:

```bash
docker compose --profile agent up -d azdevops-agent
```

2. Multi-arch build helper:

```bash
./build_push_up.sh
./build_push_up.sh --push
```

## Production Readiness Notes

1. Do not commit real AZP_TOKEN values in any tracked file
2. Prefer secret file injection for AZP_TOKEN via AZP_TOKEN_FILE
3. Pin image versions and use immutable tags in CI/CD
4. Keep Traefik and base images updated with security patches
5. Enable TLS and real domain routing for non-local environments
6. Add centralized log shipping and metrics before internet exposure

## Environment Variables

Use .env.example as baseline. Main settings:

1. HOST_HTTP_PORT: host port mapped to Traefik web entrypoint
2. AGENT_VOLUME_NAME: persisted volume name for agent files
3. TRAEFIK_LOG_LEVEL: Traefik log level
4. AZP_*: Azure DevOps agent registration settings

## Troubleshooting

1. Stack status:

```bash
docker compose ps
```

2. Service logs:

```bash
docker compose logs -f traefik
docker compose logs -f app1
```

3. Rebuild after code changes:

```bash
docker compose build app1 app1-canary app2 app3
docker compose up -d --scale app1=3 --scale app1-canary=2 app1 app1-canary app2 app3
```
