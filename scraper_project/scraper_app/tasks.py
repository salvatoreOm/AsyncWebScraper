from celery import shared_task
import requests
from bs4 import BeautifulSoup
import re

@shared_task(bind=True, autoretry_for=(requests.exceptions.RequestException,), retry_backoff=True, retry_jitter=True, retry_kwargs={'max_retries': 3})
def scrape_url(self, url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()  # Raise an exception for bad status codes
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Extract title
        title = soup.title.string.strip() if soup.title else ''
        
        # Extract description
        meta = soup.find("meta", attrs={"name": "description"})
        description = meta["content"].strip() if meta else ''
        
        # Extract and clean visible text
        visible_text = soup.get_text()
        # Clean up the text: remove excessive whitespace and newlines
        visible_text = re.sub(r'\n\s*\n', '\n\n', visible_text)  # Replace multiple newlines with double newlines
        visible_text = re.sub(r'[ \t]+', ' ', visible_text)  # Replace multiple spaces/tabs with single space
        visible_text = visible_text.strip()  # Remove leading/trailing whitespace
        
        return {
            'title': title,
            'description': description,
            'text': visible_text[:1000]  # Increased limit for more content
        }
    except Exception as e:
        # For non-retriable errors, we can just return the error
        return {'error': str(e)}
