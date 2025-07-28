from celery import shared_task
import requests
from bs4 import BeautifulSoup

@shared_task(bind=True, autoretry_for=(requests.exceptions.RequestException,), retry_backoff=True, retry_jitter=True, retry_kwargs={'max_retries': 3})
def scrape_url(self, url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()  # Raise an exception for bad status codes
        soup = BeautifulSoup(response.text, 'html.parser')
        title = soup.title.string if soup.title else ''
        meta = soup.find("meta", attrs={"name": "description"})
        description = meta["content"] if meta else ''
        visible_text = soup.get_text()
        return {
            'title': title,
            'description': description,
            'text': visible_text[:500]  # limit size
        }
    except Exception as e:
        # For non-retriable errors, we can just return the error
        return {'error': str(e)}
