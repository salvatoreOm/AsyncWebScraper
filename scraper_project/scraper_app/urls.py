from django.urls import path
from .views import scrape, get_result

urlpatterns = [
    path('scrape/', scrape),
    path('results/<str:task_id>/', get_result),
]
