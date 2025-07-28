from celery import shared_task
import requests
from bs4 import BeautifulSoup

@shared_task
def scrape_url(url):
    try:
        response = requests.get(url)
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
        return {'error': str(e)}
