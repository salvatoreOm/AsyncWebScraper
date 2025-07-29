# URL Scraper

A Django web scraper that extracts content from websites using Celery for background processing.

## Features
- REST API for URL scraping
- Background task processing with Celery
- Task monitoring with Flower
- Simple web interface
- Dockerized setup

## Quick Start

1. **Run with Docker Compose**:
   ```bash
   docker-compose up --build
   ```

2. **Access the application**:
   - **Web UI**: http://127.0.0.1:8000
   - **Flower Dashboard**: http://127.0.0.1:5555

## Usage

### Web Interface
Simply go to http://127.0.0.1:8000, enter a URL, and click "Scrape".

### API
**Start scraping**:
```bash
curl -X POST http://127.0.0.1:8000/scrape/ \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

**Check results**:
```bash
curl http://127.0.0.1:8000/results/YOUR_TASK_ID/
```

## Services
- **Web**: Django server (port 8000)
- **Worker**: Celery background tasks
- **Redis**: Message broker
- **Flower**: Task monitoring (port 5555)

## Tech Stack
- Django + Django REST Framework
- Celery + Redis
- BeautifulSoup4
- Docker + Docker Compose

