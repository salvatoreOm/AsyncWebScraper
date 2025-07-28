# Web Scraper

This is a web scraper application built with Django, Celery, and the Django REST Framework. It provides an API to scrape a given URL and can be deployed using Docker Compose.

## Architecture

The application consists of the following components:

-   **Django Web Server**: A Django application that serves the API and a simple UI.
-   **Celery Worker**: A Celery worker that processes scraping tasks in the background.
-   **Redis**: A Redis instance that serves as the message broker for Celery.
-   **Flower**: A web-based tool for monitoring Celery jobs.

## Setup & Running the Application

### With Docker Compose

1.  **Build and Run the Containers**:
    ```bash
    docker-compose up --build
    ```

2.  **Access the Application**:
    -   Web UI: `http://localhost:8000`
    -   API: `http://localhost:8000/scrape/`
    -   Flower: `http://localhost:5555`

## API Usage

### 1. Scrape a URL

-   **Endpoint**: `/scrape/`
-   **Method**: `POST`
-   **Payload**:
    ```json
    {
        "url": "https://www.example.com"
    }
    ```
-   **Example Response**:
    ```json
    {
        "task_id": "a1b2c3d4-e5f6-7890-1234-567890abcdef"
    }
    ```

### 2. Get the Result

-   **Endpoint**: `/results/<task_id>/`
-   **Method**: `GET`
-   **Example Response**:
    ```json
    {
        "status": "SUCCESS",
        "result": {
            "title": "Example Domain",
            "description": "",
            "text": "Example Domain This domain is for use in illustrative examples in documents..."
        }
    }
    ```
