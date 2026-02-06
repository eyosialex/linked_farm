Advisors:
AI Advisor: Gives advice based on your sensor readings and weather.
Expert Advisor: For professional tips.@echo off
echo ========================================================
echo       FIXING DART ANALYZER & LOCALIZATION ERRORS
echo ========================================================
echo.

echo 1. Cleaning project (deleting build artifacts)...
call flutter clean

echo.
echo 2. Forcefully removing .dart_tool cache...
if exist .dart_tool (
    rmdir /s /q .dart_tool
    echo    - .dart_tool folder deleted.
)

echo.
echo 3. Getting dependencies...
call flutter pub get

echo.
echo 4. Generating localization files...
call flutter gen-l10n

echo.
echo ========================================================
echo                  FIX COMPLETE!
echo ========================================================
echo.
echo Please restart VS Code (or your IDE) now to verify.
echo.
pause
