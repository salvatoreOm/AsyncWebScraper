#!/bin/bash

# Web Scraper Application Startup Script
# This script starts both Django development server and Celery worker

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Web Scraper Application...${NC}"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "${RED}❌ Virtual environment not found. Please create it first with: python -m venv venv${NC}"
    exit 1
fi

# Check if Redis is running
if ! redis-cli ping > /dev/null 2>&1; then
    echo -e "${RED}❌ Redis is not running. Please start Redis first.${NC}"
    echo -e "${YELLOW}   On macOS with Homebrew: brew services start redis${NC}"
    echo -e "${YELLOW}   On Ubuntu/Debian: sudo systemctl start redis-server${NC}"
    exit 1
fi

# Activate virtual environment
echo -e "${YELLOW}📦 Activating virtual environment...${NC}"
source venv/bin/activate

# Change to Django project directory
cd scraper_project

# Check if database migrations are needed
echo -e "${YELLOW}🗄️  Checking database migrations...${NC}"
python manage.py makemigrations --check > /dev/null 2>&1 || {
    echo -e "${YELLOW}   Running migrations...${NC}"
    python manage.py migrate
}

# Function to cleanup processes on exit
cleanup() {
    echo -e "\n${YELLOW}🛑 Shutting down services...${NC}"
    if [ ! -z "$DJANGO_PID" ]; then
        kill $DJANGO_PID 2>/dev/null || true
        echo -e "${GREEN}   ✅ Django server stopped${NC}"
    fi
    if [ ! -z "$CELERY_PID" ]; then
        kill $CELERY_PID 2>/dev/null || true
        echo -e "${GREEN}   ✅ Celery worker stopped${NC}"
    fi
    echo -e "${GREEN}🎉 Application stopped successfully${NC}"
}

# Set trap to cleanup on script exit
trap cleanup EXIT INT TERM

# Start Django development server in background
echo -e "${YELLOW}🌐 Starting Django development server...${NC}"
python manage.py runserver 127.0.0.1:8000 > /dev/null 2>&1 &
DJANGO_PID=$!

# Wait a moment for Django to start
sleep 3

# Check if Django started successfully
if ! curl -s http://127.0.0.1:8000/ > /dev/null; then
    echo -e "${RED}❌ Failed to start Django server${NC}"
    exit 1
fi

# Start Celery worker in background
echo -e "${YELLOW}⚡ Starting Celery worker...${NC}"
celery -A scraper_project worker --loglevel=info > /dev/null 2>&1 &
CELERY_PID=$!

# Wait a moment for Celery to start
sleep 3

# Check if Celery started successfully
if ! ps -p $CELERY_PID > /dev/null; then
    echo -e "${RED}❌ Failed to start Celery worker${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All services started successfully!${NC}"
echo -e "${BLUE}📋 Application Information:${NC}"
echo -e "   🌐 Web Interface: ${GREEN}http://127.0.0.1:8000/${NC}"
echo -e "   🔗 API Endpoints:"
echo -e "      POST ${GREEN}http://127.0.0.1:8000/scrape/${NC} - Submit URL for scraping"
echo -e "      GET  ${GREEN}http://127.0.0.1:8000/results/<task_id>/${NC} - Get scraping results"
echo -e "   ⚡ Celery Worker: ${GREEN}Running${NC}"
echo -e "   🗄️  Redis Broker: ${GREEN}Connected${NC}"
echo ""
echo -e "${YELLOW}💡 Press Ctrl+C to stop all services${NC}"

# Keep script running and wait for user interrupt
while true; do
    sleep 1
    # Check if processes are still running
    if ! ps -p $DJANGO_PID > /dev/null; then
        echo -e "${RED}❌ Django server stopped unexpectedly${NC}"
        exit 1
    fi
    if ! ps -p $CELERY_PID > /dev/null; then
        echo -e "${RED}❌ Celery worker stopped unexpectedly${NC}"
        exit 1
    fi
done 