#!/bin/sh
# OpenSmart-Russia — Автоматическое обновление списков доменов для OpenWrt / Linux
# Запуск: через cron (например, раз в неделю: 0 4 * * 1 /etc/sing-box/update-rules.sh)

set -e

RULES_DIR="/etc/sing-box/rules"
REPO_RAW_URL="https://raw.githubusercontent.com/112fm/OpenSmart-Russia/main"
TMP_DIR="/tmp/opensmart-update"

mkdir -p "$RULES_DIR" "$TMP_DIR"

fetch_file() {
    FILE="$1"
    SRC="$REPO_RAW_URL/$FILE"
    DST="$RULES_DIR/$FILE"
    TMP="$TMP_DIR/$FILE"

    if command -v curl >/dev/null 2>&1; then
        curl -sSfL "$SRC" -o "$TMP"
    elif command -v uclient-fetch >/dev/null 2>&1; then
        uclient-fetch -q "$SRC" -O "$TMP"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$SRC" -O "$TMP"
    else
        echo "Error: curl, uclient-fetch or wget is required."
        exit 1
    fi

    # Проверяем, что файл не пустой
    if [ -s "$TMP" ]; then
        if [ ! -f "$DST" ] || ! cmp -s "$TMP" "$DST"; then
            cp "$TMP" "$DST"
            echo "Updated: $FILE"
            CHANGED=1
        fi
    fi
}

CHANGED=0
fetch_file "direct-domains.txt"
fetch_file "proxy-domains.txt"
fetch_file "singbox-ruleset-direct.json"
fetch_file "singbox-ruleset-proxy.json"

rm -rf "$TMP_DIR"

if [ "$CHANGED" -eq 1 ]; then
    echo "Rules updated. Reloading sing-box service..."
    if [ -f "/etc/init.d/sing-box" ]; then
        /etc/init.d/sing-box reload 2>/dev/null || /etc/init.d/sing-box restart
    fi
else
    echo "No changes detected. Rules are up to date."
fi
