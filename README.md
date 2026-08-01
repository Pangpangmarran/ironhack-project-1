This is project 2 for the IronHack DevOps course where we are hosting a Voting app in an Kubernetes cluster. 
The actual app is the same as in project 1, the user experience should be the same. 
What's new is the backend hosting and CI/CD pipeline.
The cluster used is in another directory in wsl2 with path: 
"~\devops-controled\week13\EKS-first-cluster"

Lessons and reminders:
#1. wsl2 will create SSH issues as the IP from the wsl Linux will change when re-starting or re-booting and they have two distinct Network layers that get into "fights".

#2. There is some latency when putting it all up in the cloud, have patience.

#3. Some AWS features are automaticly added when creating the resources, these can hide away when tearing down the hosting and prevent teardown action, leaving compete or part of resources that will cost you money (CloudWatch).

----------------------------------------------------------------
Plan to convert Project 1 to Project 2:
----------------------------------------------------------------

Architecture changes:

Separate services into Deployments:
Vote (Python Flask)
Result (Node.js)
Worker (.NET)
Redis
PostgreSQL

Create Services for networking:

Vote Service (LoadBalancer or NodePort on 8080)
Result Service (LoadBalancer or NodePort on 8081)
Redis Service (ClusterIP, internal only)
PostgreSQL Service (ClusterIP, internal only)

Use ConfigMaps/Secrets for config:

Database credentials → Secrets
Environment variables → ConfigMaps
Connection strings with service names (e.g., redis:6379, db:5432)

Details on this will be in projectparts.txt where the design choices will be as well as some instructions.

Persistent storage: (some issues with the storage for postgres)

PostgreSQL needs PersistentVolume for data
Redis can use ephemeral storage (or PV if you want persistence)

Key differences from Docker Compose:

Service discovery by DNS name (built-in)
Horizontal scaling (replicas)
Health checks → livenessProbe/readinessProbe
Resource limits (CPU/memory requests)

This end snippet from the Deployment first section of voting-deployment.yaml show the solution that is not for production:  

      volumes:
      - name: db-storage
        emptyDir: {}

This is a cluster local solution and not to be used for production (repeat for memory retention).

--------------------------------------------------------------------------

To deploy this to your Kubernetes cluster:

kubectl apply -f microservicesVoting.yaml

Check deployment status:

kubectl get all -n voting-app
kubectl get svc -n voting-app
Get the external IPs for voting and results:

kubectl get svc vote result -n voting-app

Access at the LoadBalancer external IPs shown.

----------------------------------------------------------------
Namespaces
--------------------------------------------------------------------

In the deployment file there is namespace: "voting-app" on all parts as all should be in one namespace for cluster management. 

I created a monitoring area in the cluster from the AWS portal.
Both can exist in the same cluster as Namespaces divide them and there is specific resources allocated as defined in the voting-app yaml file. 

------------------------------------------------------------------
What is CI/CD?
-----------------------------------------------------------------------
CI (Continuous Integration):

Every time you push code to Git, automated tests run
Build Docker images from your code
Run security scans
If all pass → code is "integrated" and ready
CD (Continuous Deployment):

After CI passes, automatically deploy to production
Update Kubernetes with new images
Roll out changes gradually (no downtime)

What triggers the pipeline?

Push to main branch → Full CI/CD pipeline runs
Pull Request → CI only (tests, build, security checks)
Manual trigger → Deploy on-demand
For your voting app, you have 3 services:

Vote (Python Flask):

Tests: pytest or unittest
Build: Multi-stage Docker build
Push: pangpangmarran/voting-app:main-abc1234 (tag with commit hash)
Result (Node.js):

Tests: npm test or mocha
Build: Multi-stage Docker build
Push: pangpangmarran/result-app:main-abc1234
Worker (.NET):

Build: dotnet build
Push: pangpangmarran/worker-app:main-abc1234

Key Components:

1. GitHub Actions Workflow File (.github/workflows/ci-cd.yml)
Defines all steps
Runs on push/PR
Has secrets (Docker Hub credentials, K8s API token)

2. Triggers
push: [main] → Deploy to production
pull_request: [main] → Test only
workflow_dispatch → Manual trigger

3. Jobs
Build Job: Compile, test, build Docker images
Push Job: Push images to Docker Hub
Deploy Job: Update Kubernetes manifests and apply

4. Secrets
DOCKER_USERNAME → for pushing to Docker Hub
DOCKER_PASSWORD → Docker Hub token
KUBE_CONFIG → Kubernetes cluster credentials
AWS_ACCESS_KEY_ID
AWS_REGION
AWS_SECRET_ACCESS_KEY
DOCKER_CONFIG
