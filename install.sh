#!/bin/sh
set -eu
BASE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HOME/dsh-superagent"
PORT=3083

echo "== 1. check tools =="
node -v
if ! command -v pnpm >/dev/null 2>&1; then npm install -g pnpm; fi
if ! command -v git >/dev/null 2>&1; then apt-get update && apt-get install -y git; fi
if ! command -v tmux >/dev/null 2>&1; then apt-get update && apt-get install -y tmux; fi
if ! command -v gh >/dev/null 2>&1; then apt-get update && apt-get install -y gh; fi

echo "== 2. extract source =="
rm -rf "$SRC"
mkdir -p "$SRC"
tar -xzf "$BASE/dsh-superagent-src.tar.gz" -C "$SRC"

echo "== 3. install and build =="
cd "$SRC"
pnpm install
pnpm build

echo "== 4. create profile =="
if [ ! -d "$HOME/.dsh/profiles/superagent" ]; then
  dsh superagent --from-default-profile web --dump-config > /dev/null
fi
mkdir -p "$HOME/.dsh/state/superagent"
cat > "$HOME/.dsh/profiles/superagent/cordis.patch.yml" <<YAML
- id: webserver
  config:
    host: 127.0.0.1
    port: $PORT
- id: dsh-superagent
  config:
    stateDir: $HOME/.dsh/state/superagent
YAML

echo "== 5. install bundle =="
dsh plugin --profile superagent add "link:$SRC"

echo "== 6. start =="
tmux kill-session -t dsh-superagent 2>/dev/null || true
tmux new-session -d -s dsh-superagent "cd $SRC && dsh --profile superagent --no-open"
sleep 6
echo "Started. Open: http://127.0.0.1:$PORT"
echo "Logs: tmux attach -t dsh-superagent"
