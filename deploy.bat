@echo off
:: TipAI Deployment Script for Windows
:: This script automates the deployment process on Windows

echo.
echo ==========================================
echo   TipAI Django Application Deployment
echo ==========================================
echo.

:: Check if Python is installed
echo [INFO] Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python 3.8 or higher
    pause
    exit /b 1
)
echo [SUCCESS] Python found

:: Check if Git is installed
echo [INFO] Checking Git installation...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed or not in PATH
    echo Please install Git
    pause
    exit /b 1
)
echo [SUCCESS] Git found

:: Setup virtual environment
echo [INFO] Setting up virtual environment...
if not exist ".venv" (
    python -m venv .venv
    echo [SUCCESS] Virtual environment created
) else (
    echo [WARNING] Virtual environment already exists
)

:: Activate virtual environment
echo [INFO] Activating virtual environment...
call .venv\Scripts\activate.bat

:: Upgrade pip
echo [INFO] Upgrading pip...
python -m pip install --upgrade pip

:: Install dependencies
echo [INFO] Installing Python dependencies...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [SUCCESS] Dependencies installed

:: Validate ML model
echo [INFO] Validating ML model...
python -c "import joblib; import os; import numpy as np; model = joblib.load('ml_project/model/xgb_model.pkl'); test_features = np.array([[32.83, 1, 0, 3, 0, 3]]); prediction = model.predict(test_features); print(f'Model validation successful! Test prediction: ${prediction[0]:.2f}')"
if %errorlevel% neq 0 (
    echo [ERROR] Model validation failed
    pause
    exit /b 1
)
echo [SUCCESS] ML model validated

:: Setup Django
echo [INFO] Setting up Django application...
cd tip_predictor

:: Run migrations
echo [INFO] Running database migrations...
python manage.py migrate
if %errorlevel% neq 0 (
    echo [ERROR] Database migration failed
    cd ..
    pause
    exit /b 1
)
echo [SUCCESS] Migrations completed

:: Collect static files
echo [INFO] Collecting static files...
python manage.py collectstatic --noinput
if %errorlevel% neq 0 (
    echo [ERROR] Static files collection failed
    cd ..
    pause
    exit /b 1
)
echo [SUCCESS] Static files collected

:: Ask about superuser creation
set /p CREATE_SUPERUSER="Do you want to create a Django superuser? (y/n): "
if /i "%CREATE_SUPERUSER%"=="y" (
    python manage.py createsuperuser
)

:: Run tests
echo [INFO] Running tests...
python manage.py test
if %errorlevel% neq 0 (
    echo [ERROR] Tests failed
    cd ..
    pause
    exit /b 1
)
echo [SUCCESS] All tests passed

cd ..

:: Setup Git repository
echo [INFO] Setting up Git repository...
if not exist ".git" (
    git init
    echo [SUCCESS] Git repository initialized
) else (
    echo [WARNING] Git repository already exists
)

:: Add files to Git
git add .

:: Ask for commit message
set /p COMMIT_MSG="Enter commit message (or press Enter for default): "
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Initial deployment setup

git commit -m "%COMMIT_MSG%"
echo [SUCCESS] Changes committed

:: Deployment options
echo.
echo [INFO] Deployment platform options:
echo 1. Local development server
echo 2. Heroku (requires Heroku CLI)
echo 3. Docker (requires Docker Desktop)
echo 4. Manual deployment guide
echo 5. Exit

set /p PLATFORM="Choose deployment option (1-5): "

if "%PLATFORM%"=="1" goto local_server
if "%PLATFORM%"=="2" goto heroku_deploy
if "%PLATFORM%"=="3" goto docker_deploy
if "%PLATFORM%"=="4" goto manual_guide
if "%PLATFORM%"=="5" goto end

:local_server
echo [INFO] Starting local development server...
cd tip_predictor
echo.
echo [SUCCESS] Starting TipAI on http://127.0.0.1:8000/
echo Press Ctrl+C to stop the server
echo.
python manage.py runserver
goto end

:heroku_deploy
echo [INFO] Heroku deployment instructions:
echo 1. Install Heroku CLI from https://devcenter.heroku.com/articles/heroku-cli
echo 2. Run: heroku login
echo 3. Run: heroku create your-app-name
echo 4. Run: git push heroku main
echo 5. Run: heroku open
echo.
echo All necessary files (Procfile, runtime.txt) are already created!
goto end

:docker_deploy
echo [INFO] Building Docker image...
docker build -t tipai-django .
if %errorlevel% neq 0 (
    echo [ERROR] Docker build failed. Make sure Docker Desktop is running.
    goto end
)

echo [INFO] Running Docker container...
docker run -d -p 8000:8000 --name tipai-app tipai-django
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start Docker container
    goto end
)

echo [SUCCESS] Docker container running on http://localhost:8000
goto end

:manual_guide
echo.
echo ==========================================
echo         Manual Deployment Guide
echo ==========================================
echo.
echo Your application is ready for deployment! Here are your options:
echo.
echo 1. HEROKU:
echo    - Files ready: Procfile, runtime.txt, requirements.txt
echo    - Run: git push heroku main
echo.
echo 2. RAILWAY:
echo    - Connect GitHub repo at railway.app
echo    - Automatic deployment
echo.
echo 3. RENDER:
echo    - Connect GitHub repo at render.com
echo    - Build: pip install -r requirements.txt
echo    - Start: cd tip_predictor ^&^& python manage.py runserver 0.0.0.0:$PORT
echo.
echo 4. DIGITAL OCEAN:
echo    - Use Docker image with docker-compose.yml
echo.
echo 5. AWS/AZURE/GCP:
echo    - Use provided Dockerfile and requirements.txt
echo.
goto end

:end
echo.
echo [SUCCESS] Deployment process completed!
echo.
echo Your TipAI application features:
echo - Smart ML predictions using XGBoost
echo - Beautiful, responsive design
echo - Complete user experience with multiple pages
echo - Production-ready code with error handling
echo.
echo Thank you for using TipAI! 🚀
echo.
pause
