#!/bin/bash

# Cleanup Fleek Scraper from Kubernetes
echo "🧹 Cleaning up Fleek Scraper from Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    exit 1
fi

echo "🗑️  Deleting all resources..."
kubectl delete -k k8s/manifests/

echo "🔍 Checking if namespace still exists..."
if kubectl get namespace fleek-scraper &> /dev/null; then
    echo "⏳ Waiting for namespace to be fully deleted..."
    kubectl delete namespace fleek-scraper --wait=true
fi

echo "✅ Cleanup complete!"
echo "📝 All Fleek Scraper resources have been removed from the cluster." 