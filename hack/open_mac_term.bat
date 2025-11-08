@echo off
:: Sikarugir環境を引き継いだbashプロンプトをTerminal.appで開始する

set "WIN_SCPT_PATH=%~dp0_open_mac_term.scpt"

FOR /F "usebackq" %%i IN (`winepath -u "%WIN_SCPT_PATH%"`) DO (
    SET "UNIX_SCPT_PATH=%%i"
)

IF NOT DEFINED UNIX_SCPT_PATH (
    echo "ERROR: winepath failed or returned empty."
    pause
    exit /b
)

@echo on
cmd /c start /unix /usr/bin/osascript %UNIX_SCPT_PATH%
@echo off

echo finished.

