#!/bin/sh
# Install sway-alttab.
#   ./install.sh            scripts for your user + the Alt-release helper (asks for sudo)
#   ./install.sh --no-helper   scripts only (Alt+Tab then confirms after a 0.8s pause)
set -e
cd "$(dirname "$0")"
BIN="$HOME/.local/bin"

mkdir -p "$BIN"
install -m 755 bin/workspace-history bin/ws-switcher-overlay extras/workspace-icons "$BIN/"
echo "Installed scripts to $BIN"

if [ "$1" != "--no-helper" ]; then
  echo "Installing the alt-release-watch system service (needs sudo)..."
  sudo install -m 755 helper/alt-release-watch /usr/local/lib/alt-release-watch
  sudo install -m 644 helper/alt-release-watch.service /etc/systemd/system/alt-release-watch.service
  sudo systemctl daemon-reload
  sudo systemctl enable --now alt-release-watch.service
  echo "alt-release-watch is $(systemctl is-active alt-release-watch.service)"
fi

python3 -c 'import gi; gi.require_version("GtkLayerShell", "0.1")' 2>/dev/null || cat <<'MSG'

Note: the on-screen strip needs PyGObject + gtk-layer-shell. On Debian/Ubuntu:
  sudo apt install python3-gi gir1.2-gtk-3.0 gir1.2-gtklayershell-0.1
MSG

cat <<'MSG'

Last step: add the lines from config/sway.conf (or config/i3.conf) to your WM config,
then reload it (Sway: swaymsg reload).
MSG
