# DevOps Project End to End CI/CD.

### About
Java maven project deployment to k8 cluster.

### Infrastructre 
- Terraform for managing the resources in aws .
- JavaSpring Boot + mysql database.
- AWS - VPC, Security Groups.
- AWS - EC2.
- Docker.
- kubernetes cluster  (1 master , 2 slaves )
- Jenkins server for ci/cd 
- solarqube - code quality check.
- Nexus -  artifact the package.
- Monitoring (promethus+ grafana).
- Linux + bash scripts .

### CI/CD Process (Jenkins Pipeline):

- Git Checkout – Jenkins fetches the latest code from GitHub.
- Compile & Test – Maven compiles the code and runs unit tests.
- File System Scan & Code Quality Check – SonarQube analyzes code quality.
- Vulnerability Scan – Trivy scans for vulnerabilities of the code.
- Build & Package Application – Maven builds and packages the application.
- Push Artifact to Nexus Repository – The packaged application is stored.
- Containerization & Deployment
	- Docker Build & Tag – A Docker image is created.
	- Docker Image Scan – Trivy performs a security scan using also Trivy.
	- Push Docker Image to Registry – The image is uploaded.
	- Deploy to Kubernetes – The application is deployed to Kubernetes.
	- Verify Deployment – Deployment is validated.
- Monitoring & Notifications
	- Prometheus & Grafana monitor performance.

### Images
![screenshot](pipeline_result.png)
![screenshot](grafana.png)
![screenshot](nexus.png)
![screenshot](sonarqube.png)
