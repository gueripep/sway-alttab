#!/bin/sh
# Remove sway-alttab (scripts + helper service). Remove the config lines yourself.
set -e
pkill -f '^python3 .*workspace-history' 2>/dev/null || true
rm -f "$HOME/.local/bin/workspace-history" "$HOME/.local/bin/ws-switcher-overlay" "$HOME/.local/bin/workspace-icons"
if [ -f /etc/systemd/system/alt-release-watch.service ]; then
  sudo systemctl disable --now alt-release-watch.service
  sudo rm -f /etc/systemd/system/alt-release-watch.service /usr/local/lib/alt-release-watch
  sudo systemctl daemon-reload
fi
echo "Removed. Delete the sway-alttab lines from your WM config and reload it."
