# Dask ML on Kubernetes (GKE)

`dask-kubernetes` creates a Dask cluster on Google Container Engine.
It uses Google Cloud Storage bucket to store your notebook for persistence so there is no need to use a persistent volume.

## How to use

0. Create a GCS bucket for storing your notebooks
1. Change `c.GoogleStorageContentManager.default_path` in `jupyter-config.py` to your GCS path
3. Create a GKE cluster of your choice (Recommend 2CPU 7.5G or larger each node), make sure turn on **legacy authorisation mode**

For example the following bash script:

   ```
   project_name=brightwrite-211800
   zone_name=us-west1-b
   zone_name2=us-west1
   gcloud beta container --project "${project_name}" clusters create "jupyter-1" --zone "${zone_name}" --username "admin" --cluster-version "1.9.7-gke.6" --machine-type "n1-highcpu-64" --image-type "COS" --disk-type "pd-ssd" --disk-size "100" --scopes "https://www.googleapis.com/auth/cloud-platform" --min-cpu-platform "Intel Skylake" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --network "projects/${project_name}/global/networks/default" --subnetwork "projects/${project_name}/regions/${zone_name2}/subnetworks/default" --enable-legacy-authorization --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade --enable-autorepair
   ```
4. Make sure the container image specified in kube/30-deployment.yaml is as desired. This docker image will be deployed to the workers.
5. Check that the limits specified in kube/30-deployment.yamls is consistent with your cluster definition above in terms of number of CPUs, memory, etc.
6. Run `kubectl apply -f ./kube/ --validate=false`
7. Connect to service using port forwarding `kubectl port-forward svc/svc-notebooks 8888:8888`, or use the public ip from `kubectl get svc`
8. Start using cluster!
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
