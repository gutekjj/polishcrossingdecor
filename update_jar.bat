@echo off
setlocal

set "JAR=builds\polishcrossingdecor.jar"
set "UPDATED_JAR=builds\polishcrossingdecorupdated.jar"
set "EXTRACT_DIR=extracted_jar"
set "PARENT_ASSETS_1.16.5=assets-1.16.5"
set "PARENT_ASSETS_1.12.2=assets-1.12.2"
set "TMP_JAR=%UPDATED_JAR%.tmp"
@RD /S /Q  "%UPDATED_JAR%"
where 7z >nul 2>&1
if errorlevel 1 (
    echo 7z.exe not found in PATH. Put 7z.exe in PATH or next to this script.
    exit /b 1
)

set /p "VERSION=Enter target Minecraft version (e.g., 1.16.5 or 1.19.2 or 1.20.1): "

if "%VERSION%"=="1.16.5" (
    set "PARENT_ASSETS=%PARENT_ASSETS_1.16.5%"
) else if "%VERSION%"=="1.12.2" (
    set "PARENT_ASSETS=%PARENT_ASSETS_1.12.2%"
) else if "%VERSION%"=="1.20.1" (
    set "PARENT_ASSETS=%PARENT_ASSETS_1.16.5%"
) else (
    echo Unsupported version "%VERSION%". Supported versions are 1.16.5, 1.12.2 and 1.20.1.
    exit /b 1
)

if exist "%EXTRACT_DIR%" rd /s /q "%EXTRACT_DIR%"

mkdir "%EXTRACT_DIR%"
7z x "%JAR%" -o"%EXTRACT_DIR%" -y
if errorlevel 1 (
    echo Extraction failed.
    exit /b 1
)

if exist "%EXTRACT_DIR%\assets" rd /s /q "%EXTRACT_DIR%\assets"

if not exist "%PARENT_ASSETS_1.16.5%" (
    echo Source assets folder "%PARENT_ASSETS_1.16.5%" not found.
    exit /b 1
)
if not exist "%PARENT_ASSETS_1.12.2%" (
    echo Source assets folder "%PARENT_ASSETS_1.12.2%" not found.
    exit /b 1
)
xcopy "%PARENT_ASSETS%" "%EXTRACT_DIR%\assets" /e /i /h /y >nul

pushd "%EXTRACT_DIR%"
7z a -tzip "..\%TMP_JAR%" * -r -mx=9 >nul
popd

if not exist "%TMP_JAR%" (
    echo Repack failed.
    exit /b 1
)

move /y "%TMP_JAR%" "%UPDATED_JAR%" >nul
@RD /S /Q "%EXTRACT_DIR%"
echo Done. Created "%UPDATED_JAR%".
endlocal
pause