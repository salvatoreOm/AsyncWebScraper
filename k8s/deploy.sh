#!/bin/bash

# Deploy Fleek Scraper to Kubernetes
echo "🚀 Deploying Fleek Scraper to Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster. Please check your kubeconfig."
    exit 1
fi

echo "📦 Building Docker image..."
docker build -t fleek-scraper:latest .

# If using minikube, load the image
if command -v minikube &> /dev/null && minikube status &> /dev/null; then
    echo "📥 Loading image to minikube..."
    minikube image load fleek-scraper:latest
fi

echo "🔧 Applying Kubernetes manifests..."
kubectl apply -k k8s/manifests/

echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/redis -n fleek-scraper
kubectl wait --for=condition=available --timeout=300s deployment/web -n fleek-scraper
kubectl wait --for=condition=available --timeout=300s deployment/worker -n fleek-scraper
kubectl wait --for=condition=available --timeout=300s deployment/flower -n fleek-scraper

echo "✅ Deployment complete!"

echo "📊 Getting service information..."
kubectl get services -n fleek-scraper

echo "🌐 Access URLs:"
echo "Web Application: http://$(minikube service web-service -n fleek-scraper --url 2>/dev/null || echo 'localhost:8000')"
echo "Flower Dashboard: http://$(minikube service flower-service -n fleek-scraper --url 2>/dev/null || echo 'localhost:5555')"

echo "📝 To check pod status: kubectl get pods -n fleek-scraper"
echo "📝 To view logs: kubectl logs -f deployment/web -n fleek-scraper" 