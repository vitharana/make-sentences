@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"


REM === Show current date and time (formatted) ===
set "rawDate=%date:/=-%"
set "rawTime=%time::=-%"

REM Remove milliseconds (anything after .)
for /f "tokens=1 delims=." %%t in ("%rawTime%") do set "shortTime=%%t"

echo Date: %rawDate% Time: %shortTime%





REM === Show folder name ===
for %%F in (".") do set "currentFolder=%%~nxF"
echo.
echo Folder: !currentFolder!


REM === Get cleaned folder name ===
for %%F in (".") do set "rawFolder=%%~nxF"
set "cleanFolder=!rawFolder!"

:trimLoop
set "char=!cleanFolder:~0,1!"
if "!char!"=="" goto :trimDone

REM Check if first character is a digit, dot, space, or dash
echo 0123456789.- | findstr /c:"!char!" >nul
if !errorlevel! == 0 (
    set "cleanFolder=!cleanFolder:~1!"
    goto :trimLoop
)

:trimDone
REM Replace spaces with dashes
set "cleanFolder=!cleanFolder: =-!"

echo Modified Name: !cleanFolder!


echo.
echo.
echo =======================================================

REM === Show last modified file ===
for /f "delims=" %%a in ('dir /b /a:-d /o:-d /t:w') do (
    set "lastFile=%%a"
    goto :break
)
:break
echo Last modified file: !lastFile!

echo =======================================================


echo.


REM Check if this is already a git repo
if not exist ".git" (
    REM Ask for GitHub repo name
    set /p repoName="Enter GitHub repo name: "

    REM Get GitHub username from gh
    for /f "tokens=* delims=" %%u in ('gh api user --jq ".login"') do set "USERNAME=%%u"

    REM Initialize Git and create remote repo with exact name
    git init
    gh repo create "!USERNAME!/!repoName!" --private --source=. --remote=upstream

    REM First-time push
    git add .
    set /p commitMsg="Enter commit message: "
    git commit -m "!commitMsg!"
    git push --set-upstream upstream master
    git push
) else (
    REM Already initialized, just commit and push
    git add .
    set /p commitMsg="Enter commit message: "
    git commit -m "!commitMsg!"
    git push
)

endlocal
pause