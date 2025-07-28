from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import ScrapeRequestSerializer
from .tasks import scrape_url
from celery.result import AsyncResult

@api_view(['POST'])
def scrape(request):
    serializer = ScrapeRequestSerializer(data=request.data)
    if serializer.is_valid():
        url = serializer.validated_data['url']
        task = scrape_url.delay(url)
        return Response({'task_id': task.id}, status=202)
    return Response(serializer.errors, status=400)

@api_view(['GET'])
def get_result(request, task_id):
    result = AsyncResult(task_id)
    return Response({
        'status': result.status,
        'result': result.result if result.ready() else None
    })
