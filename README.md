# Dask ML on Kubernetes (GKE)

`dask-kubernetes` creates a Dask cluster on Google Container Engine.
It uses Google Cloud Storage bucket to store your notebook for persistence so there is no need to use a persistent volume.

## How to use

0. Create a GCS bucket for storing your notebooks
1. Change `c.GoogleStorageContentManager.default_path` in `jupyter-config.py` to your GCS path
3. Create a GKE cluster of your choice (Recommend 2CPU 7.5G or larger each node)
4. Make the default account `cluster-admin`, in order to create role/service account for jupyter notebooks
    ```
    kubectl create clusterrolebinding cluster-admin-binding \ 
      --clusterrole cluster-admin \
      --user $(gcloud config get-value account)
    ```
5. `kubectl apply -f ./kube/`
6. Connect to service using port forwarding `kubectl port-forward svc/svc-notebooks 8888:8888`
7. Start using cluster!
    ```
    from dask_kubernetes import KubeCluster
    
    # See a sample worker spec in `config/worker-spec-sample.yaml`
    cluster = KubeCluster.from_yaml('...your yaml path')
    
    cluster.scale(3)  # the desired number of nodes
    
    
    from dask.distributed import Client
    client = Client(cluster)
    ```
    
### How to customise the image

1. Change the `Dockerfile`, build your image, and push it to any of the image storage service.
2. Change the image name in `30-deployment.yaml` file
3. Apply your kubernetes configuration