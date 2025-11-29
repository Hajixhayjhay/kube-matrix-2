# **Kube-Matrix Developer Guide** 

# **⭐ 1\. Prerequisites**

## **Install AWS CLI**

Mac:

`brew install awscli`

Ubuntu:

`sudo apt update`  
`sudo apt install awscli -y`

Windows:

* `Install from AWS MSI installer`.

### **Configure AWS CLI**

Run:

`aws configure`

Enter:

`AWS Access Key ID: <your key>`  
`AWS Secret Access Key: <your secret>`  
`Default region: us-east-1`  
`Output format: json`

# **Install Docker on Ubuntu (Linux)**

### **Step 1 — Uninstall old versions (optional)**

`sudo apt-get remove docker docker-engine docker.io containerd runc`

### **Step 2 — Update packages**

`sudo apt-get update`

### **Step 3 — Install required packages**

`sudo apt-get install \`  
    `ca-certificates \`  
    `curl \`  
    `gnupg \`  
    `lsb-release -y`

### **Step 4 — Add Docker’s official GPG key**

`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg`

### **Step 5 — Add Docker apt repository**

`echo \`  
  `"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \`  
  `$(lsb_release -cs) stable" | \`  
  `sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`

### **Step 6 — Install Docker Engine**

`sudo apt-get update`  
`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y`

### **Step 7 — Verify installation**

`docker --version`  
`docker run hello-world`

### **Step 8 — Allow running docker without sudo**

`sudo usermod -aG docker $USER`

# **Install kubectl on Ubuntu / Linux**

### **Step 1 — Download latest stable kubectl**

`curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`

### **Step 2 — Make it executable**

`chmod +x kubectl`

### **Step 3 — Move it into PATH**

`sudo mv kubectl /usr/local/bin/`

### **Step 4 — Verify**

`kubectl version --client`

---

# **⭐ 2\. Generate kubeconfig (Two Methods)**

## **Method A — generate-kubeconfig.sh**

Use this script:

### **generate-kubeconfig.sh**

`#!/bin/bash`

`# Script to generate kubeconfig for a developer for an existing EKS cluster`

`# -------------------------`

`# Configurable parameters`

`# -------------------------`

`CLUSTER_NAME=${1:-"<your-cluster-name>"}     # Default: replace with your cluster name`

`REGION=${2:-"us-east-1"}                   # Default: N. Virginia`

`KUBECONFIG_FILE=${3:-"$HOME/.kube/config"}  # Default kubeconfig location`

`# -------------------------`

`# Prerequisites check`

`# -------------------------`

`command -v aws >/dev/null 2>&1 || { echo >&2 "AWS CLI not installed. Exiting."; exit 1; }`

`command -v kubectl >/dev/null 2>&1 || { echo >&2 "kubectl not installed. Exiting."; exit 1; }`

`# -------------------------`

`# Generate kubeconfig`

`# -------------------------`

`echo "Generating kubeconfig for EKS cluster '$CLUSTER_NAME' in region '$REGION'..."`

`aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME --kubeconfig $KUBECONFIG_FILE`

`# -------------------------`

`# Test connection`

`# -------------------------`

`echo "Testing connection..."`

`kubectl get nodes`

`if [ $? -eq 0 ]; then`

    `echo "✅ Kubeconfig setup successful. You can now run kubectl commands."`

`else`

    `echo "❌ Failed to connect. Check your AWS credentials and cluster permissions."`

`fi`

Run:

`chmod +x generate-kubeconfig.sh`

`./generate-kubeconfig.sh`

Usage:

`bash generate-kubeconfig.sh <eks-cluster-name> <region-name>`

Example:

`bash generate-kubeconfig.sh dev-km-eks us-east-1`

Test:

`kubectl get nodes`

---

## 

## **Method B — No script, run from terminal**

`aws eks update-kubeconfig --region us-east-1 --name <cluster-name>`

`kubectl get nodes`

You should see your EKS worker nodes.

---

# **⭐ 2\. Basic kubectl sanity tests**

---

## **Test 1 — Create a namespace**

`kubectl create namespace sanity-test`

`kubectl get ns`

---

## 

## **Test 2 — Simple NGINX Pod**

`# nginx-pod.yaml`

`apiVersion: v1`

`kind: Pod`

`metadata:`

  `name: nginx-test`

  `namespace: sanity-test`

`spec:`

  `containers:`

    `- name: nginx`

      `image: nginx:latest`

      `ports:`

        `- containerPort: 80`

Apply:

`kubectl apply -f nginx-pod.yaml`

`kubectl get pods -n sanity-test`

`kubectl logs nginx-test -n sanity-test`

---

## 

## **Test 3 — NGINX Deployment**

`# nginx-deploy.yaml`

`apiVersion: apps/v1`

`kind: Deployment`

`metadata:`

  `name: nginx-deploy`

  `namespace: sanity-test`

`spec:`

  `replicas: 2`

  `selector:`

    `matchLabels:`

      `app: nginx`

  `template:`

    `metadata:`

      `labels:`

        `app: nginx`

    `spec:`

      `containers:`

        `- name: nginx`

          `image: nginx`

Apply:

`kubectl apply -f nginx-deploy.yaml`

`kubectl get deploy -n sanity-test`

`kubectl get pods -n sanity-test`

---

## **Test 4 — LoadBalancer Service (ALB or NLB)**

### **service.yaml**

`apiVersion: v1`

`kind: Service`

`metadata:`

  `name: nginx-lb`

  `namespace: sanity-test`

`spec:`

  `type: LoadBalancer`

  `selector:`

    `app: nginx`

  `ports:`

    `- protocol: TCP`

      `port: 80`

      `targetPort: 80`

Apply:

`kubectl apply -f service.yaml`

`kubectl get svc -n sanity-test`

Within a minute, AWS will assign an external LB hostname.

Test in browser:

`http://<external-lb-dns>`

---

# **⭐ 3\. Login to ECR (VERY IMPORTANT)**

ECR requires a password-based login using AWS CLI.

Run:

`aws ecr get-login-password --region us-east-1 \`  
`| docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com`

Replace `<AWS_ACCOUNT_ID>` with your 12-digit account ID.

---

# **⭐ 4\. Build Docker Image**

From your project root or whichever directory:

### **Example for frontend:**

**Dockerfile**

`# ---------- Build Stage ----------`

`FROM node:18-alpine AS build`

`WORKDIR /app`

`# Install only production deps first for caching`

`COPY package*.json ./`

`RUN npm ci --only=production`

`# Copy source code`

`COPY . .`

`# ---------- Runtime Stage ----------`

`FROM node:18-alpine`

`# Create app directory`

`WORKDIR /app`

`# Copy only production node_modules & build artifacts`

`COPY --from=build /app/node_modules ./node_modules`

`COPY --from=build /app . /`

`# Expose backend port`

`EXPOSE 3001`

`# Start backend`

`CMD ["node", "src/server.js"]`

Run the following:

`docker build -t frontend-app .`

### **Example for Backend:**

**Dockerfile**

`# ---------- Build Stage ----------`

`FROM node:18-alpine AS build`

`WORKDIR /app`

`# Copy package files and install ONLY production dependencies`

`COPY package*.json ./`

`RUN npm ci --only=production`

`# Copy full application source`

`COPY . .`

`# ---------- Runtime Stage ----------`

`FROM node:18-alpine`

`WORKDIR /app`

`# Copy production node_modules + app source from build stage`

`COPY --from=build /app/node_modules ./node_modules`

`COPY --from=build /app . /`

`# Expose backend port`

`EXPOSE 3001`

`# Start backend`

`CMD ["node", "src/server.js"]`

Run this command:

`docker build -t backend-app .`

Database image:

`docker build -t database-app .`

---

# 

# **⭐ 5\. Tag the Image (VERY IMPORTANT)**

You must tag the local image with the ECR repository URL.

Use this format:

`<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/<repo-name>:<tag>`

### **Frontend:**

`docker tag frontend-app:latest \`  
`<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/frontend-repo:latest`

### **Backend:**

`docker tag backend-app:latest \`  
`<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend-repo:latest`

### **Database:**

`docker tag database-app:latest \`  
`<AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/database-repo:latest`

---

# **⭐ 6\. Push Image to ECR**

### **Frontend push:**

`docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/frontend-repo:latest`

### **Backend push:**

`docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/backend-repo:latest`

### 

### **Database push:**

`docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/database-repo:latest`

---

# **⭐ 7\. Verify That Images Are in ECR**

`aws ecr describe-images \`  
  `--repository-name frontend-repo \`  
  `--region us-east-1`

Repeat for backend, database.

---

# **⭐ Your Repositories From Terraform**

Since you created:

* `frontend-repo`

* `backend-repo`

* `database-repo`

The URLs should look like:

123456789012.dkr.ecr.us-east-1.amazonaws.com/frontend-repo  
123456789012.dkr.ecr.us-east-1.amazonaws.com/backend-repo  
123456789012.dkr.ecr.us-east-1.amazonaws.com/database-repo

---

# 

# **⭐ 8\. Deploy 3-Tier Architecture from ECR**

Here is a clean sample showing how EKS pulls images from ECR.

---

## **Frontend Deployment**

frontend-deployment.yaml

`apiVersion: apps/v1`  
`kind: Deployment`  
`metadata:`  
  `name: frontend`  
  `namespace: default`  
`spec:`  
  `replicas: 2`  
  `selector:`  
    `matchLabels:`  
      `tier: frontend`  
  `template:`  
    `metadata:`  
      `labels:`  
        `tier: frontend`  
    `spec:`  
      `containers:`  
        `- name: frontend`  
          `image: <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/frontend-repo:latest`  
          `ports:`  
            `- containerPort: 3000`

#### **Service file:**

**frontend-service.yaml**

`apiVersion: v1`  
`kind: Service`  
`metadata:`  
  `name: frontend`  
`spec:`  
  `type: LoadBalancer   # Or ClusterIP if using Ingress`  
  `ports:`  
    `- port: 80`  
      `targetPort: 3000`  
  `selector:`  
    `app: frontend`

---

## **Backend Deployment**

**backend-deployment.yaml**

`apiVersion: apps/v1`  
`kind: Deployment`  
`metadata:`  
  `name: backend`  
`spec:`  
  `replicas: 2`  
  `selector:`  
    `matchLabels:`  
      `tier: backend`  
  `template:`  
    `metadata:`  
      `labels:`  
        `tier: backend`  
    `spec:`  
      `containers:`  
        `- name: backend`  
          `image: <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/backend-repo:latest`  
          `env:`  
            `- name: DB_HOST`  
              `value: "<aurora-cluster-endpoint>"`  
            `- name: DB_USER`  
              `value: "admin"`  
            `- name: DB_PASS`  
              `valueFrom:`  
                `secretKeyRef:`  
                  `name: aurora-secret`  
                  `key: password`

**backend-service.yaml**  
`apiVersion: v1`  
`kind: Service`  
`metadata:`  
  `name: backend`  
`spec:`  
  `type: ClusterIP`  
  `ports:`  
    `- port: 3001`  
      `targetPort: 3001`  
  `selector:`  
    `app: backend`

**backend-config.yaml**  
`apiVersion: v1`  
`kind: ConfigMap`  
`metadata:`  
  `name: backend-config`  
`data:`  
  `db_host: "<aurora-cluster-endpoint>"`

---

# **⭐ 9\. EKS → Aurora Serverless Connection Test**

**From a pod:**

`kubectl run sqltest --image=mysql:8 -it --rm -- bash`

**Inside the pod:**

`mysql -h <aurora-endpoint> -u admin -p`

If this works → networking & SGs are correct.

# **Connect to EKS Cluster**

### **Option 1: If you have the generate-kubeconfig.sh**

Run:

`./generate-kubeconfig.sh`

---

### **Option 2: Using AWS CLI**

`aws eks update-kubeconfig --name <your-cluster-name> --region us-east-1`

Verify:

`kubectl get nodes`  
`kubectl get pods -A`  
`kubectl get deployments`

If you see nodes → you are connected.

---

# 

# **⭐ Run YAML files (apply)**

Go to the folder where your YAMLs are stored, for example:

`cd k8s/`

Now run:

`kubectl apply -f .`

This applies **all YAML files in the folder**.

---

# **Or apply a single file:**

`kubectl apply -f frontend-deployment.yaml`  
`kubectl apply -f frontend-service.yaml`  
`kubectl apply -f backend-deployment.yaml`  
`kubectl apply -f backend-service.yaml`

---

# **🔁 If you modify a file later**

Just reapply:

`kubectl apply -f backend-deployment.yaml`

No need to delete anything.

---

# **❌ If you want to delete all resources**

Careful — but this works:

`kubectl delete -f .`

Or delete specific ones:

`kubectl delete -f frontend-deployment.yaml`

---

# **⭐ Check if everything is running**

### **Pods:**

`kubectl get pods`

### **Services:**

`kubectl get svc`

### **Logs:**

`kubectl logs -f deployment/backend`

### **Events:**

`kubectl get events --sort-by=.metadata.creationTimestamp`  
