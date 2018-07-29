# Dask ML on Kubernetes (GKE)

`dask-kubernetes` creates a Dask cluster on Google Container Engine.

## How to use

1. Create a GKE cluster of your choice (Recommend 2CPU 7.5G or larger each node)
2. Make the default account `cluster-admin`, 
as it is required to create a separate role and role binding for `dask distributed` so it does not run on admin account.
    ```
    kubectl create clusterrolebinding cluster-admin-binding \ 
      --clusterrole cluster-admin \
      --user $(gcloud config get-value account)
    ```
3. `kubectl apply -f ./kube/`
4. Connect to service using port forwarding `kubectl port-forward svc/svc-notebooks 8888:8888`
4. Start using cluster!
    ```
    from dask_kubernetes import KubeCluster
    cluster = KubeCluster.from_yaml('../config/worker-spec.yaml')
    
    cluster.scale(10)
    
    from dask.distributed import Client
    client = Client(cluster)
    ```
    
