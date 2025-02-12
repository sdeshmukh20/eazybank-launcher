#!/bin/bash

# Exit on any error
set -e

# Function to print colored messages
print_message() {
  echo -e "$1"
}

# Check if the environment name is provided
if [ -z "$1" ]; then
  print_message "Project Directory path is required (e.g./Users/sdeshmukh/DEV/visionmax/ebsetup). Exiting."
  exit 1
fi

# Check if the environment name is provided
if [ -z "$2" ]; then
  print_message "Deployment branch-name is required (e.g.release1.0). Exiting."
  exit 1
fi

ROOT_DIRECTORY=$1

print_message "Setting up EB-System in directory: ${ROOT_DIRECTORY}"

# 1. Create directories
#INFRA_DIR=${ROOT_DIRECTORY}/eazybank-system/infra
#SERVICE_DIR="${ROOT_DIRECTORY}/eazybank-system/services"
cd "${ROOT_DIRECTORY}"
print_message "Creating directories..."
mkdir -p "eazybank-system/infra/eazybank-deployment"
mkdir -p "eazybank-system/services/eazybank-service"
mkdir -p "eazybank-system/client-ui/eazy-bank-ui"

# 2. Clone repositories
print_message "Cloning eazybank-service repository."
cd eazybank-system
SERVICE_BRANCH="$2"
git clone -b "$SERVICE_BRANCH" https://github.com/sdeshmukh20/eazybank-service.git services/eazybank-service

print_message "Cloning eazybank-deployment repository..."
DEPLOYMENT_BRANCH="$2"
#read -p "Enter the branch name for eazybank-deployment: " DEPLOYMENT_BRANCH
git clone -b "$DEPLOYMENT_BRANCH" https://github.com/sdeshmukh20/eazybank-deployment.git infra/eazybank-deployment

print_message "Cloning eazybank-ui repository..."

#read -p "Enter the branch name for eazybank-client-ui: " DEPLOYMENT_BRANCH
git clone -b "$DEPLOYMENT_BRANCH" https://github.com/sdeshmukh20/eazy-bank-ui client-ui/eazy-bank-ui

# 3. Build eazybank-service
print_message "Building eazybank-service with Maven..."
cd "services/eazybank-service"
mvn clean install -Dmaven.test.skip=true

# 4. Copy the target jar to the deployment directory
print_message "Copying the built jar to the deployment build directory..."
TARGET_JAR=$(find target -type f -name "*.jar" | grep -v "original")
DEPLOYMENT_BUILD_DIR="../../infra/eazybank-deployment/docker/service-config/app/build"

mkdir -p "$DEPLOYMENT_BUILD_DIR"
cp "$TARGET_JAR" "$DEPLOYMENT_BUILD_DIR"

# 5. Print success message
print_message "Backend code downloaded successfully!"

cd ../../infra/eazybank-deployment/bootstrap
print_message "Executing bootstrap from launcher"
chmod +x ./main.sh
#./main.sh $2

