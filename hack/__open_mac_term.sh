#!/bin/bash

# 環境変数ダンプファイルを使ってSikarugir内部環境のbashを立ち上げる

# Sikarugir環境の.app
SIKARUGIR_APP="/Users/ponzu840w/Applications/Sikarugir/Windows.app"
# Sikarugir環境のwineバイナリ
SIKARUGIR_WINE_BIN="${SIKARUGIR_APP}/Contents/SharedSupport/wine/bin"
# ライブラリのパス 本当はこれも書き出させたかったがSIPが許さないらしい?
#DYLD_FALLBACK_LIBRARY_PATH=""
# AppleScriptが書き出した生の環境変数ダンプファイル
RAW_DUMP_FILE="/tmp/sikarugir_env_raw.sh"
# このスクリプトが作成する修正済みダンプファイル
FIXED_DUMP_FILE="/tmp/sikarugir_env_fixed.sh"

# bash が解釈できない ( ) を含む行を削除する
grep -v 'export [^=]*[()]' "$RAW_DUMP_FILE" > "$FIXED_DUMP_FILE"

# 修正済みのファイルをsourceで読み込み、環境変数を復元する
source "$FIXED_DUMP_FILE"
# 不要となったダンプファイルを削除
rm "$RAW_DUMP_FILE" "$FIXED_DUMP_FILE"

# SikarugirのwineバイナリにPATHを通す
# (.bashrcとかで)
#export PATH="$SIKARUGIR_WINE_BIN:$PATH"
export DYLD_FALLBACK_LIBRARY_PATH="/Users/ponzu840w/Applications/Sikarugir/Windows.app/Contents/Frameworks/moltenvkcx:/Users/ponzu840w/Applications/Sikarugir/Windows.app/Contents/SharedSupport/wine/lib:/Users/ponzu840w/Applications/Sikarugir/Windows.app/Contents/SharedSupport/wine/lib64:/Users/ponzu840w/Applications/Sikarugir/Windows.app/Contents/Frameworks:/Users/ponzu840w/Applications/Sikarugir/Windows.app/Contents/Frameworks/GStreamer.framework/Libraries:/opt/wine/lib:/usr/lib:/usr/libexec:/usr/lib/system:/opt/X11/lib"

# プロンプト
PS1="(Sikarugir)${PS1}"

# デバッグ表示
wine --version
#export -p
