#!/bin/bash
set -e

INSTALL_DIR="/opt/orbit"
REPO="MalikHw/orbit-screensaver-cpp"

echo "=== orbit screensaver installer ==="

# get latest release zip url
echo "fetching latest release..."
ZIP_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep "browser_download_url.*orbit-linux.zip" \
    | cut -d '"' -f 4)

if [ -z "$ZIP_URL" ]; then
    # fallback: try artifact named orbit-linux (no zip)
    ZIP_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
        | grep "browser_download_url.*orbit-linux" \
        | cut -d '"' -f 4)
fi

if [ -z "$ZIP_URL" ]; then
    echo "error: could not find linux release asset"
    exit 1
fi

echo "downloading from $ZIP_URL..."
TMP=$(mktemp -d)
curl -fsSL "$ZIP_URL" -o "$TMP/orbit-linux.zip"

echo "installing to $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"
sudo unzip -o "$TMP/orbit-linux.zip" -d "$INSTALL_DIR" 2>/dev/null || sudo cp "$TMP/orbit-linux" "$INSTALL_DIR/orbit_screensaver"
sudo chmod +x "$INSTALL_DIR/orbit_screensaver"

# symlink to /usr/local/bin
sudo ln -sf "$INSTALL_DIR/orbit_screensaver" /usr/local/bin/orbit_screensaver

rm -rf "$TMP"

echo ""
echo "installed! run with:"
echo "  orbit_screensaver           <- runs fullscreen"
echo "  orbit_screensaver -c        <- configure"
echo ""
echo "NOTE: transparency/blur only works on X11 with a compositor (picom etc)"
echo "      Wayland users: bg mode will fallback to black, sorry lol"
echo ""

# detect desktop env and give hints
if [ -n "$WAYLAND_DISPLAY" ]; then
    echo "you're on Wayland - to use as screensaver, check your DE's screensaver settings"
    echo "and point it to: $INSTALL_DIR/orbit_screensaver"
elif [ -n "$DISPLAY" ]; then
    echo "you're on X11 - to use as screensaver:"
    echo "  xscreensaver users: add to ~/.xscreensaver manually"
    echo "  GNOME: gnome-screensaver-command or use a wrapper"
    echo "  or just run it manually when you want lol"
fi
