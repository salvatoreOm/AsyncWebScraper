# URL Scraper

A Django-based web scraping tool that processes requests in the background using Celery and Redis. Includes a REST API, simple UI, and supports deployment via Docker and tried the best to do the bonus Kubernetes Part.

---

-> Thought Process & Steps Followed

1. Initialized Django project and app (`scraper_project`, `scraper_app`)
2. Set up Django REST Framework
3. Initialized Git and committed regularly
4. Created `/scrape/` POST endpoint to accept URLs and trigger background tasks
5. Created `/results/<task_id>/` GET endpoint to return task status and results
6. Configured Celery with Django and Redis
7. Installed and configured `django-celery-results` for task result tracking
8. Implemented scraping logic using BeautifulSoup
9. Integrated Flower to monitor Celery tasks
10. Exposed Flower via Docker Compose
11. Wrote Dockerfiles for web app, worker, and Flower
12. Defined services in `docker-compose.yaml`: web, worker, redis, flower
13. Tested API using Postman and curl
14. Documented setup steps and architecture in README
15. Added retry logic to Celery tasks
16. Built a basic UI to submit URLs and view results

---

-> What It Does

* Allows users to submit a URL via web interface or API
* Runs scraping tasks in the background to keep the app responsive
* Tracks job progress and results using Celery and Redis
* Enables monitoring through Flower
* Provides a clean and simple web UI
* Works seamlessly using Docker or Kubernetes setups

---

-> Get Started Quickly

Start with Docker Compose:

docker-compose up --build


Access locally:

* Web App: [http://127.0.0.1:8000](http://127.0.0.1:8000)
* Flower: [http://127.0.0.1:5555](http://127.0.0.1:5555)

---

-> Kubernetes & Helm Deployment

Requirements:

* A Kubernetes cluster (e.g., Minikube, Kind, or cloud)
* kubectl configured
* Docker installed

Option 1: Scripted Deployment

./k8s/deploy.sh


Option 2: Kustomize

kubectl apply -k k8s/manifests/


Option 3: Helm

helm install fleek-scraper k8s/helm/fleek-scraper/


Access the services:

* Web: [http://your-cluster/web-service](http://your-cluster/web-service)
* Flower: [http://your-cluster/flower-service:5555](http://your-cluster/flower-service:5555) (default credentials: admin/password)

To clean up:

./k8s/cleanup.sh


-> How to Use

Web UI:
Go to [http://127.0.0.1:8000](http://127.0.0.1:8000), enter a URL, and click "Scrape".

API:

Start a scraping task:

curl -X POST http://127.0.0.1:8000/scrape/ \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'


Check task results:

curl http://127.0.0.1:8000/results/YOUR_TASK_ID/


---

-> Architecture

* Web App: Django backend (runs on port 8000)
* Worker: Celery handles background tasks
* Redis: Message broker for Celery
* Flower: Task monitoring UI (runs on port 5555)

Kubernetes setup includes:

* Separate Deployments and Services for each component
* ConfigMaps for environment variables
* Health checks and resource limits
* Helm and Kustomize support for streamlined deployment

---

-> Scaling & Monitoring

Scale deployments:

kubectl scale deployment web --replicas=3 -n fleek-scraper
kubectl scale deployment worker --replicas=5 -n fleek-scraper


Enable autoscaling:

kubectl autoscale deployment web --cpu-percent=70 --min=2 --max=10 -n fleek-scraper


Check status:

kubectl get pods -n fleek-scraper


View logs:

kubectl logs -f deployment/web -n fleek-scraper
kubectl logs -f deployment/worker -n fleek-scraper


Port forward for local access:

kubectl port-forward service/web-service 8000:80 -n fleek-scraper
kubectl port-forward service/flower-service 5555:5555 -n fleek-scraper


---

-> Built With

* Django and Django REST Framework
* Celery with Redis as broker
* BeautifulSoup for web scraping
* Docker and Docker Compose
* Kubernetes, Helm, and Kustomize for deployment

---

-> Security & Production Tips

* Update Flower credentials in production
* Store secrets using Kubernetes Secrets or `.env` files
* Apply network policies for pod communication
* Enable RBAC and security context policies
* Use persistent volumes for Redis
* Configure TLS using Ingress
* Set up monitoring/logging (e.g., Prometheus, Grafana)

---

-> Troubleshooting

| Issue                  | Solution                                   |
| ---------------------- | ------------------------------------------ |
| Pods not starting      | Check resource limits and cluster capacity |
| Services not reachable | Verify Ingress and service configuration   |
| Task failures          | Inspect Celery and Redis logs              |

---

-> Credits

This project demonstrates a production-ready, scalable web scraping architecture using Django, Celery, Redis, Docker, and Kubernetes, with clean API integration and monitoring support.
