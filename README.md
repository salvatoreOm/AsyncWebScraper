To solve this task, my thought process was:

1. Initialized Django project and app (`scraper_project`, `scraper_app`)
2. Set up Django REST Framework
3. Initialized Git and committed regularly
4. Created `/scrape/` POST endpoint to accept URLs and trigger background tasks
5. Created `/results/<task_id>/` GET endpoint to return task status and results
6. Set up Celery with Django and Redis
7. Installed and configured `django-celery-results` for result tracking
8. Implemented background scraping task using BeautifulSoup
9. Integrated Flower for monitoring Celery tasks
10. Exposed Flower through Docker Compose
11. Wrote Dockerfiles for web, worker, and Flower
12. Created `docker-compose.yaml` with services: web, worker, redis, flower
13. Tested API using Postman and curl
14. Wrote README with setup steps, architecture, and example requests
15. Added task retry logic in Celery
16. Built a simple UI to submit URLs and display results



URL Scraper:
A Django-based tool to scrape website content. It works in the background using Celery and has a simple interface to make it easy to use.

What It Does:
Lets you submit a URL to scrape through a web page or API.
Runs scraping tasks in the background (so the app doesn’t hang).
Lets you monitor background tasks with Flower.
Comes with a basic web UI.
Everything runs smoothly using Docker.


Get Started Quickly:

Start the app with Docker Compose:
docker-compose up --build
Open in your browser:
Web UI: http://127.0.0.1:8000
Flower (task monitor): http://127.0.0.1:5555


How to Use:

Web Interface
Just open http://127.0.0.1:8000, paste a URL, and hit “Scrape”.

API Usage:
📤 Start a scrape:

curl -X POST http://127.0.0.1:8000/scrape/ \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
📥 Check results:

curl http://127.0.0.1:8000/results/YOUR_TASK_ID/


What’s Running:

Web App: Django server (runs on port 8000)
Worker: Celery worker to handle background jobs
Redis: Used to manage background task queues
Flower: Monitor background tasks (runs on port 5555)

Built With:

Django + Django REST Framework
Celery + Redis
BeautifulSoup4 (for scraping)
Docker + Docker Compose