@echo off
REM ⚠️ IMPORTANT: Set these environment variables before running!
REM Read the SECURITY_REMEDIATION.md file for setup instructions

REM Get your values from: https://app.supabase.com/project/_/settings/api
REM ONLY the SERVICE_ROLE_KEY should be set for this script

if "%SUPABASE_URL%"=="" (
    echo ERROR: SUPABASE_URL environment variable not set
    echo Please read SECURITY_REMEDIATION.md for instructions
    pause
    exit /b 1
)

if "%SUPABASE_SERVICE_ROLE_KEY%"=="" (
    echo ERROR: SUPABASE_SERVICE_ROLE_KEY environment variable not set
    echo Please read SECURITY_REMEDIATION.md for instructions
    pause
    exit /b 1
)

cd /d "%~dp0"
node scripts\admin_create_user.js "{\"email\":\"admin@school.com\",\"password\":\"Admin123!\",\"role\":\"admin\",\"full_name\":\"Administrator\"}"
pause