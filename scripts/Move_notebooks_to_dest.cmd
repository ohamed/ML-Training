@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Transfer .ipynb files (skip existing + ignore checkpoints)

REM =========================
REM User-configurable paths
REM =========================
::set "SOURCE=%cd%\Traning"
set "SOURCE=%cd%
set "DEST=C:\Users\oalan\Documents\GitHub\ML-Traning\notebooks"

REM ---- Normalize trailing backslashes
if "%SOURCE:~-1%"=="\" set "SOURCE=%SOURCE:~0,-1%"
if "%DEST:~-1%"=="\" set "DEST=%DEST:~0,-1%"

echo [INFO] Source     = "%SOURCE%"
echo [INFO] Destination= "%DEST%"
echo.

REM ---- Validate source; prepare destination
if not exist "%SOURCE%\" (
  echo [ERROR] Source folder not found: "%SOURCE%"
  exit /b 1
)
if not exist "%DEST%\" (
  echo [INFO] Destination does not exist. Creating...
  mkdir "%DEST%" || (
    echo [ERROR] Failed to create destination folder: "%DEST%"
    exit /b 1
  )
)

REM ---- Counters
set "copied=0"
set "skipped=0"
set "ignored=0"
set "errors=0"

REM =========================
REM Copy only missing .ipynb, ignore .ipynb_checkpoints
REM =========================
for /R "%SOURCE%" %%F in (*.ipynb) do (
  set "srcFile=%%F"
  set "srcDir=%%~dpF"

  REM If srcDir contains ".ipynb_checkpoints\", ignore
  set "chk=!srcDir:.ipynb_checkpoints\=!"
  if not "!chk!"=="!srcDir!" (
    echo [IGNORE] Skipping checkpoint file: %%~nxF
    set /a ignored+=1
  ) else (
    REM Build destination path preserving relative structure
    set "relDir=!srcDir:%SOURCE%\=!"
    set "destDir=%DEST%\!relDir!"
    set "destFile=!destDir!%%~nxF"

    if not exist "!destDir!" (
      mkdir "!destDir!" 2>nul
    )

    if exist "!destFile!" (
      echo [SKIP] %%~nxF already exists in "!destDir!"
      set /a skipped+=1
    ) else (
      copy /y "%%F" "!destDir!" >nul
      if errorlevel 1 (
        echo [ERR ] Failed to copy: "%%F"
        set /a errors+=1
      ) else (
        echo [COPY] %%~nxF
        set /a copied+=1
      )
    )
  )
)

echo.
echo [DONE] Copied: !copied! ^| Skipped: !skipped! ^| Ignored: !ignored! ^| Errors: !errors!
exit /b 0