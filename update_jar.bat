@echo off
setlocal

set "JAR=builds\polishcrossingdecor.jar"
set "UPDATED_JAR=builds\polishcrossingdecorupdated.jar"
set "EXTRACT_DIR=extracted_jar"
set "PARENT_ASSETS=assets"
set "TMP_JAR=%UPDATED_JAR%.tmp"
@RD /S /Q  "%UPDATED_JAR%"
where 7z >nul 2>&1
if errorlevel 1 (
    echo 7z.exe not found in PATH. Put 7z.exe in PATH or next to this script.
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

if not exist "%PARENT_ASSETS%" (
    echo Source assets folder "%PARENT_ASSETS%" not found.
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