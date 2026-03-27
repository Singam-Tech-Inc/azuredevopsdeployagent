#!/usr/bin/env bash
set -euo pipefail

AGENT_DIR=/azagent
AGENT_STAMP=.image_agent_stamp
AGENT_ID=4.269.0-arm64
mkdir -p "$AGENT_DIR"
cd "$AGENT_DIR"

# Refresh persisted agent files from image when stamp is missing/stale.
# This prevents reusing old x64 files from an existing Docker volume on ARM hosts.
if [ ! -f "$AGENT_STAMP" ] || [ "$(cat "$AGENT_STAMP")" != "$AGENT_ID" ]; then
  find "$AGENT_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  cp -a /opt/agent/. "$AGENT_DIR"/
  echo "$AGENT_ID" > "$AGENT_STAMP"
fi

# Ensure the non-root runtime user can access persisted files.
chown -R agent:agent "$AGENT_DIR"

# Optional secret-file support for production deployments.
if [ -z "${AZP_TOKEN:-}" ] && [ -n "${AZP_TOKEN_FILE:-}" ]; then
  AZP_TOKEN="$(cat "$AZP_TOKEN_FILE")"
fi

# Required environment variables
: "${AZP_URL:?AZP_URL is required (e.g. https://dev.azure.com/yourOrg)}"
: "${AZP_TOKEN:?AZP_TOKEN is required (your PAT)}"
: "${AZP_PROJECT:?AZP_PROJECT is required (project name)}"
: "${AZP_ENVIRONMENT:=development}"
: "${AZP_AGENT_NAME:=agent-${HOSTNAME}}"

# Configure the agent only if it isn't already configured.
# The agent writes a `.agent` file when config is complete.
if [ ! -f ".agent" ]; then
  echo "Configuring Azure DevOps agent..."
  su -s /bin/bash agent -c "./config.sh \
    --unattended \
    --replace \
    --environment \
    --environmentname '${AZP_ENVIRONMENT}' \
    --acceptTeeEula \
    --agent '${AZP_AGENT_NAME}' \
    --url '${AZP_URL}' \
    --work _work \
    --projectname '${AZP_PROJECT}' \
    --auth PAT \
    --token '${AZP_TOKEN}'"
else
  echo "Agent already configured; skipping config step."
fi

# In containers, run.sh keeps the agent process in the foreground.
# Use exec so the agent process becomes PID 1 (best practice for containers).
exec su -s /bin/bash agent -c "./run.sh"
