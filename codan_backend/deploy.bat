@echo off
echo ==========================================
echo CODean Laravel Backend Deployment Script
echo For domain: codean.brodims.my.id
echo ==========================================
echo.
echo This is a deployment guide for Windows/WSL/Linux
echo.
echo Please follow these steps manually:
echo.
echo 1. Install WSL (Windows Subsystem for Linux) if not installed
echo    - Open PowerShell as Administrator
echo    - Run: wsl --install
echo.
echo 2. Open Ubuntu WSL terminal
echo    - Search for "Ubuntu" in Start Menu
echo.
echo 3. Copy the deploy.sh script to WSL
echo    - Copy codan_backend folder to WSL home directory
echo    - Example: cp -r /mnt/c/Users/YourUser/path/to/codan_backend ~/
echo.
echo 4. Run the deployment script in WSL
echo    - cd ~/codan_backend
echo    - chmod +x deploy.sh
echo    - sudo ./deploy.sh
echo.
echo 5. Or follow manual deployment steps:
echo    - See DEPLOYMENT_GUIDE.md for detailed instructions
echo.
echo ==========================================
echo Deployment Files Created:
echo 1. .env.production - Production environment file
echo 2. deploy.sh - Linux deployment script
echo 3. DEPLOYMENT_GUIDE.md - Complete deployment guide
echo ==========================================
pause