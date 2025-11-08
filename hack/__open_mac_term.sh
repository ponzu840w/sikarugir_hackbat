#!/bin/bash

# 環境変数ダンプファイルを使ってSikarugir内部環境のbashを立ち上げる

# 一時ファイル
DYLD_DUMP_FILE="/tmp/sikarugir_dyld_path.txt"
RAW_DUMP_FILE="/tmp/sikarugir_env_raw.sh"
FIXED_DUMP_FILE="/tmp/sikarugir_env_fixed.sh"

# bash が解釈できない ( ) を含む行とPATHを除外
grep -v 'export [^=]*[()]' "$RAW_DUMP_FILE" |\
grep -v '^export PATH=' > "$FIXED_DUMP_FILE"

# 環境変数を復元
source "$FIXED_DUMP_FILE"

# WINEPREFIX から .app のパスを抽出
# (WINEPREFIX が /.../Windows.app/Contents/... という形式であると仮定)
SIKARUGIR_APP=$(echo "$WINEPREFIX" | grep -o '.*/Windows\.app')

if [ -z "$SIKARUGIR_APP" ]; then
    echo "ERROR: Could not determine SIKARUGIR_APP path from WINEPREFIX."
    echo "WINEPREFIX was: $WINEPREFIX"
    return
fi

# PATHは既存のものにSikarugirのwine/binを乗っけるだけにする
SIKARUGIR_WINE_BIN="${SIKARUGIR_APP}/Contents/SharedSupport/wine/bin"
export PATH="$SIKARUGIR_WINE_BIN:$PATH"

# DYLD_FALLBACK_LIBRARY_PATHはMac環境ではSIPで端折られるので
# その手前の.batでダンプしたものを復元する
if [ ! -f "$DYLD_DUMP_FILE" ]; then
  echo "ERROR: DYLD dump file not found: $DYLD_DUMP_FILE"
  return
fi
DYLD_UNIX_PATHS=$(cat "$DYLD_DUMP_FILE" | tr -d '"')
export DYLD_FALLBACK_LIBRARY_PATH="$DYLD_UNIX_PATHS"

# 不要ファイル削除
rm "$RAW_DUMP_FILE" "$FIXED_DUMP_FILE" "$DYLD_DUMP_FILE"

### ここから装飾 ###

# .app のベース名を取得 (例: "Windows.app" -> "Windows")
APP_NAME=$(basename "$SIKARUGIR_APP" .app)

# Wine のバージョンを取得
WINE_VERSION=$(wine --version 2>/dev/null || echo "Not Found")

# CドライブのUNIXパスを取得
if ! C_DRIVE_PATH=$(wine winepath -u 'C:\' 2>/dev/null); then
    echo "WARNING: Could not determine C_DRIVE_PATH."
    C_DRIVE_PATH="$HOME" # エラーの場合はホームディレクトリにフォールバック
fi

# カラーコード
WINE_COLOR='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

# バナー
clear

printf "${BOLD}================================================================${RESET}\n"
printf        " 🍷🍾🍷       Sikarugir -Wrapped Wine- Environment       🍾🍷🍾 \n"
printf "${BOLD}================================================================${RESET}\n"
printf "\n"
printf "${BOLD}Application:${RESET} ${WINE_COLOR}${APP_NAME}.app${RESET}\n"
printf "${BOLD}  .app Path:${RESET} ${SIKARUGIR_APP}\n"
printf "${BOLD}Wine Prefix:${RESET} ${WINEPREFIX}\n"
printf "${BOLD} C: Drive:${RESET} ${C_DRIVE_PATH}\n"
printf "\n"
printf "${BOLD}--- Environment Status ---${RESET}\n"
printf "${BOLD}Wine Version:${RESET} ${WINE_COLOR}${WINE_VERSION}${RESET}\n"
printf "${BOLD} PATH added:${RESET} ${SIKARUGIR_WINE_BIN}\n"

if [ -n "$DYLD_FALLBACK_LIBRARY_PATH" ]; then
    printf "${BOLD}DYLD Library:${RESET} Loaded successfully.\n"
else
    printf "${BOLD}DYLD Library:${RESET} Load FAILED.\n"
fi
printf "\n"
printf "Type ${BOLD}'wine cmd'${RESET} to enter wine command-prompt.\n"
printf "${BOLD}================================================================${RESET}\n"
printf "\n"

# プロンプト
export PS1="\[${WINE_COLOR}\](🍷${APP_NAME}.app)\[${RESET}\]${PS1}"

cd "$HOME"

