#!/bin/zsh

set -u

LABEL="com.amaw.swedish-government-v6-overnight-20260917-fixed4"
RUN_DIR="/Users/martin/Projects/AMAW/dev/runs/swedish-government-v6-overnight-20260917-fixed4"

finish() {
  status=$?
  printf '%s\n' "$status" > "$RUN_DIR/exit-status"
  /bin/launchctl remove "$LABEL" >/dev/null 2>&1 || true
  exit "$status"
}

trap finish EXIT

cd /Users/martin/Projects/AMAW || exit 1

/opt/homebrew/bin/uv run amaw run /Users/martin/Projects/AMAW/scenarios/swedish-government-v6 \
  --player-model deepseek/deepseek-v4-flash-0731 \
  --umpire-model deepseek/deepseek-v4-flash-0731 \
  --seed 20260921 \
  --request-timeout-seconds 300 \
  --max-cycles 10000 \
  --diplomacy-concurrency 8 \
  --cons-concurrency 8 \
  --activation-mode single_shot \
  --player-temperature 0 \
  --player-reasoning-effort low \
  --player-max-tokens 8000 \
  --umpire-temperature 0 \
  --umpire-reasoning-effort low \
  --umpire-max-tokens 16000 \
  --max-llm-iterations 24 \
  --max-tool-calls 40 \
  --max-messages-per-activation 5 \
  --max-messages-per-phase 30 \
  --max-activations-per-opportunity 12 \
  --log-level DEBUG \
  --log-file "$RUN_DIR/run.log" \
  --stream-game-details \
  --export-path "$RUN_DIR/export.json" \
  --run-class playtest \
  >"$RUN_DIR/stdout.log" 2>&1
