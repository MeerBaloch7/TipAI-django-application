#!/bin/bash

# TipAI Deployment Script
# This script automates the deployment process

set -e  # Exit on any error

echo "🚀 Starting TipAI Deployment Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Python is installed
check_python() {
    print_status "Checking Python installation..."
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        print_success "Python $PYTHON_VERSION found"
    else
        print_error "Python 3 is not installed. Please install Python 3.8 or higher."
        exit 1
    fi
}

# Check if Git is installed
check_git() {
    print_status "Checking Git installation..."
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version | cut -d' ' -f3)
        print_success "Git $GIT_VERSION found"
    else
        print_error "Git is not installed. Please install Git."
        exit 1
    fi
}

# Setup virtual environment
setup_venv() {
    print_status "Setting up virtual environment..."
    
    if [ ! -d ".venv" ]; then
        python3 -m venv .venv
        print_success "Virtual environment created"
    else
        print_warning "Virtual environment already exists"
    fi
    
    # Activate virtual environment
    source .venv/bin/activate
    print_success "Virtual environment activated"
    
    # Upgrade pip
    pip install --upgrade pip
    print_success "Pip upgraded"
}

# Install dependencies
install_dependencies() {
    print_status "Installing Python dependencies..."
    pip install -r requirements.txt
    print_success "Dependencies installed"
}

# Run Django setup
setup_django() {
    print_status "Setting up Django application..."
    
    cd tip_predictor
    
    # Run migrations
    print_status "Running database migrations..."
    python manage.py migrate
    print_success "Migrations completed"
    
    # Collect static files
    print_status "Collecting static files..."
    python manage.py collectstatic --noinput
    print_success "Static files collected"
    
    # Create superuser (optional)
    read -p "Do you want to create a Django superuser? (y/n): " CREATE_SUPERUSER
    if [ "$CREATE_SUPERUSER" = "y" ] || [ "$CREATE_SUPERUSER" = "Y" ]; then
        python manage.py createsuperuser
    fi
    
    cd ..
}

# Run tests
run_tests() {
    print_status "Running tests..."
    cd tip_predictor
    
    # Run Django tests
    python manage.py test
    print_success "All tests passed"
    
    cd ..
}

# Validate ML model
validate_model() {
    print_status "Validating ML model..."
    
    python3 << EOF
import joblib
import os
import numpy as np

try:
    # Check if model file exists
    model_path = 'ml_project/model/xgb_model.pkl'
    if not os.path.exists(model_path):
        raise FileNotFoundError(f'Model file not found: {model_path}')
    
    # Load model
    model = joblib.load(model_path)
    print(f'✓ Model loaded successfully: {type(model)}')
    
    # Test prediction
    test_features = np.array([[32.83, 1, 0, 3, 0, 3]])
    prediction = model.predict(test_features)
    print(f'✓ Test prediction: \${prediction[0]:.2f}')
    
    if prediction[0] <= 0:
        raise ValueError('Model prediction should be positive')
    
    print('✓ Model validation successful!')
    
except Exception as e:
    print(f'✗ Model validation failed: {e}')
    exit(1)
EOF
    
    print_success "ML model validated"
}

# Setup Git repository
setup_git() {
    print_status "Setting up Git repository..."
    
    if [ ! -d ".git" ]; then
        git init
        print_success "Git repository initialized"
    else
        print_warning "Git repository already exists"
    fi
    
    # Add all files
    git add .
    
    # Check if there are changes to commit
    if git diff --staged --quiet; then
        print_warning "No changes to commit"
    else
        # Commit changes
        read -p "Enter commit message (default: 'Initial deployment setup'): " COMMIT_MSG
        COMMIT_MSG=${COMMIT_MSG:-"Initial deployment setup"}
        git commit -m "$COMMIT_MSG"
        print_success "Changes committed"
    fi
}

# Deploy to platform
deploy_to_platform() {
    print_status "Deployment platform options:"
    echo "1. Heroku"
    echo "2. Railway"
    echo "3. Render"
    echo "4. Docker (local)"
    echo "5. Skip deployment"
    
    read -p "Choose deployment platform (1-5): " PLATFORM
    
    case $PLATFORM in
        1)
            deploy_heroku
            ;;
        2)
            deploy_railway
            ;;
        3)
            deploy_render
            ;;
        4)
            deploy_docker
            ;;
        5)
            print_warning "Skipping deployment"
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
}

# Heroku deployment
deploy_heroku() {
    print_status "Deploying to Heroku..."
    
    if ! command -v heroku &> /dev/null; then
        print_error "Heroku CLI is not installed. Please install it first."
        return 1
    fi
    
    # Login to Heroku
    print_status "Please login to Heroku..."
    heroku login
    
    # Create Heroku app
    read -p "Enter Heroku app name: " APP_NAME
    heroku create $APP_NAME
    
    # Add git remote
    git remote add heroku https://git.heroku.com/$APP_NAME.git
    
    # Deploy
    git push heroku main
    
    # Open app
    heroku open --app $APP_NAME
    
    print_success "Deployed to Heroku successfully!"
}

# Railway deployment
deploy_railway() {
    print_status "For Railway deployment:"
    echo "1. Go to https://railway.app"
    echo "2. Connect your GitHub repository"
    echo "3. Select this repository"
    echo "4. Railway will automatically deploy"
    print_success "Railway deployment instructions provided"
}

# Render deployment
deploy_render() {
    print_status "For Render deployment:"
    echo "1. Go to https://render.com"
    echo "2. Connect your GitHub repository"
    echo "3. Create a new Web Service"
    echo "4. Use these settings:"
    echo "   - Build Command: pip install -r requirements.txt"
    echo "   - Start Command: cd tip_predictor && python manage.py runserver 0.0.0.0:\$PORT"
    print_success "Render deployment instructions provided"
}

# Docker deployment
deploy_docker() {
    print_status "Building Docker image..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        return 1
    fi
    
    # Build image
    docker build -t tipai-django .
    
    # Run container
    print_status "Running Docker container..."
    docker run -d -p 8000:8000 --name tipai-app tipai-django
    
    print_success "Docker container running on http://localhost:8000"
}

# Main deployment process
main() {
    echo "🎯 TipAI Django Application Deployment"
    echo "======================================"
    
    # Pre-flight checks
    check_python
    check_git
    
    # Setup environment
    setup_venv
    install_dependencies
    
    # Validate application
    validate_model
    setup_django
    run_tests
    
    # Version control
    setup_git
    
    # Deploy
    deploy_to_platform
    
    echo ""
    print_success "🎉 Deployment process completed!"
    echo ""
    echo "Next steps:"
    echo "1. Test your application thoroughly"
    echo "2. Set up monitoring and logging"
    echo "3. Configure custom domain (if needed)"
    echo "4. Set up SSL certificate"
    echo "5. Configure environment variables for production"
    echo ""
    echo "Your TipAI application is ready to serve intelligent tip predictions! 🚀"
}

# Run main function
main "$@"
