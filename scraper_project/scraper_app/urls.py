from django.urls import path
from .views import scrape, get_result, index

urlpatterns = [
    path('', index),
    path('scrape/', scrape),
    path('results/<str:task_id>/', get_result),
]
