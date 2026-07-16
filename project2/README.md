This is project 2 for the IronHack DevOps course where we are hosting a Voting app in an Kubernetes cluster. 
The actual app is the same as in project 1, the user experience should be the same. 
What's new is the backend hosting and CI/CD pipeline. 

Lessons and reminders:
#1. wsl and wsl2 will create SSH issues as the IP from the wsl Linux will change when re-starting.
#2. There is some latency when putting it all up in the cloud, have patience.
#3. Some AWS features are automaticly added when creating the resources, these can hide away when tearing down the hosting and prevent teardown action, leaving compete or part of resources that will cost you money.

Plan to convert Project 1 to Project 2:

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

Persistent storage:
PostgreSQL needs PersistentVolume for data
Redis can use ephemeral storage (or PV if you want persistence)

Key differences from Docker Compose:

Service discovery by DNS name (built-in)
Horizontal scaling (replicas)
Health checks → livenessProbe/readinessProbe
Resource limits (CPU/memory requests)