@echo off
:: Sikarugir環境を引き継いだbashプロンプトをTerminal.appで開始する

:: macOS の /tmp ディレクトリに対応する Windows パスを取得
FOR /F "usebackq" %%i IN (`winepath -w /tmp`) DO ( SET "TMP_WIN_PATH=%%i")
IF NOT DEFINED TMP_WIN_PATH (
    echo "ERROR: winepath -w /tmp failed."
    pause
    exit /b
)

:: DYLD_FALLBACK_LIBRARY_PATH の内容を一時ファイルに書き出す
echo "%DYLD_FALLBACK_LIBRARY_PATH%" > "%TMP_WIN_PATH%\sikarugir_dyld_path.txt"

:: ターミナル起動用の.scptスクリプトのUNIXフルパスを取得
set "WIN_SCPT_PATH=%~dp0_open_mac_term.scpt"

FOR /F "usebackq" %%i IN (`winepath -u "%WIN_SCPT_PATH%"`) DO ( SET "UNIX_SCPT_PATH=%%i")
IF NOT DEFINED UNIX_SCPT_PATH (
    echo "ERROR: winepath failed or returned empty."
    pause
    exit /b
)

:: ターミナル起動用の.scptスクリプトを実行
@echo on
cmd /c start /unix /usr/bin/osascript %UNIX_SCPT_PATH%
@echo off

echo finished.

