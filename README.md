# Wiliot Assignment

## 1. Overview

This repository contains the code for a Flask application, infrastructure configuration using Terraform, and deployment configuration using a Helm chart.

## 2. Directory Structure

- `application/`: Contains the Flask application code and Dockerfile.
- `terraform/`: Contains Terraform configurations for setting up infrastructure.
- `helm/`: Contains the Helm chart for deploying the application on Kubernetes.

## 3. Getting Started

### 3.1. Prerequisites

- AWS cli
- Docker
- Kubernetes
- Helm
- Terraform
- Run ./set-variables.sh file

### 3.2. Running the Application

#### 3.2.1. Using Docker

1. Build the Docker image:
    ```bash
    docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/wiliot-assignment:1.0.0 application/
    ```

2. Run the Docker container:
    ```bash
    docker run -p 8080:8080 ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/wiliot-assignment:1.0.0
    ```

#### 3.2.2. Using Terraform, Kubernetes and Helm

##### 3.2.2.1. Pre-Requisites
   - Create tfstate bucket
   ```bash
   aws s3api create-bucket --bucket ${TFSTATE_BUCKET_NAME} --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1
   ```

   - Create limited user to read/write tfstate file inside previous bucket and note the access key and secret key
   ```bash
   aws iam create-user --user-name ${TFSTATE_BUCKET_NAME}
   aws iam create-policy --policy-name ${TFSTATE_BUCKET_NAME}-policy --policy-document file://${TFSTATE_BUCKET_NAME}-policy.json
   aws iam attach-user-policy --user-name ${TFSTATE_BUCKET_NAME} --policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${TFSTATE_BUCKET_NAME}-policy
   aws --profile wiliot iam create-access-key --user-name ${TFSTATE_BUCKET_NAME}
   ```

   - Create a Route53 Zone and configure nameservers into domain
   This example considers a domain named my-assignments.net

##### 3.2.2.2. Initialize Terraform using the access key and secret key created in the previous step:

   ```bash
   cd terraform/
   terraform init \
    -backend-config="bucket=${TFSTATE_BUCKET_NAME}" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=eu-west-1" \
    -backend-config="access_key=${TFSTATE_ACCESS_KEY}" \
    -backend-config="secret_key=${TFSTATE_SECRET_KEY}"
   ```

##### 3.2.2.3. Apply the Terraform configuration:

   ```bash
   cd terraform \
   terraform apply
   cd ..
   ```

##### 3.2.2.4. Push Docker Image to ECR

   ```bash
   docker tag wiliot-assignment ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/wiliot-assignment:1.0.0
   aws ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
   docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/wiliot-assignment:1.0.0
   ```

##### 3.2.2.5. Package the Helm chart:

   ```bash
   helm package helm/wiliot-assignment
   ```

##### 3.2.2.6. Deploy the Helm chart:

   ```bash
   helm install -n wiliot-assignment wiliot-assignment ./wiliot-assignment-1.0.0.tgz
   ```

#### 3.2.3. Accessing the App:

https://app.my-assignments.net/

https://app.my-assignments.net/health