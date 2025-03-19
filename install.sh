#!/bin/bash

set -e

APP_DIR="/opt/notion-wrapper"
BIN_LINK="/usr/local/bin/notion"
DESKTOP_FILE="$HOME/.local/share/applications/notion.desktop"

echo "Installing..."

if ! command -v node &> /dev/null; then
  echo "Node.js is not installed. Installing..."
  sudo apt update
  sudo apt install -y nodejs npm
fi

if ! command -v npm &> /dev/null; then
  echo "npm is missing! Installation failed."
  exit 1
fi

sudo rm -rf "$APP_DIR"
sudo git clone https://github.com/redajn/notion-wrapper.git "$APP_DIR"
sudo chown -R $USER:$USER "$APP_DIR"
chmod +x "$APP_DIR/run.sh"
sudo ln -sf "$APP_DIR/run.sh" "$BIN_LINK"

if [ ! -f "$APP_DIR/node_modules/.bin/electron" ]; then
  echo "Electron is missing. Installing..."
  cd "$APP_DIR"
  npm install electron
  sudo chown root:root "$APP_DIR/node_modules/electron/dist/chrome-sandbox"
  sudo chmod 4755 "$APP_DIR/node_modules/electron/dist/chrome-sandbox"
fi

mkdir -p "$HOME/.local/share/applications/"
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Notion
Comment=Notion Wrapper by redajn
Exec=$APP_DIR/run.sh
Icon=$APP_DIR/assets/icon.png
Terminal=false
Type=Application
Categories=Utility;
EOF

update-desktop-database "$HOME/.local/share/applications/"

echo "Installation complete!"
