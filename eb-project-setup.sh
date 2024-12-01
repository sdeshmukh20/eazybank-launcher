#!/bin/bash

# Exit on any error
set -e

# Function to print colored messages
print_message() {
  echo -e "\e[1;34m$1\e[0m"
}

ROOT_DIRECTORY="/Users/sdeshmukh/DEV/visionmax/ebsetup"

print_message "Setting up EB-System in directory: "$ROOT_DIRECTORY

# 1. Create directories
print_message "Creating directories..."
mkdir -p $ROOT_DIRECTORY/eazybank-system/services
mkdir -p $ROOT_DIRECTORY/eazybank-system/infra

# 2. Clone repositories
print_message "Cloning eazybank-service repository."
SERVICE_BRANCH="release-11-udiscontinue"

git clone -b "$SERVICE_BRANCH" https://github.com/sdeshmukh20/eazybank-service.git $ROOT_DIRECTORY/eazybank-system/services/eazybank-service

print_message "Cloning eazybank-deployment repository..."
DEPLOYMENT_BRANCH="develop"
#read -p "Enter the branch name for eazybank-deployment: " DEPLOYMENT_BRANCH
git clone -b "$DEPLOYMENT_BRANCH" https://github.com/sdeshmukh20/eazybank-deployment.git $ROOT_DIRECTORY/eazybank-system/infra/eazybank-deployment

# 3. Build eazybank-service
print_message "Building eazybank-service with Maven..."
cd $ROOT_DIRECTORY/eazybank-system/services/eazybank-service
mvn clean install -Dmaven.test.skip=true

# 4. Copy the target jar to the deployment directory
print_message "Copying the built jar to the deployment build directory..."
TARGET_JAR=$(find target -type f -name "*.jar" | grep -v "original")
DEPLOYMENT_BUILD_DIR="../../infra/eazybank-deployment/docker/service-config/app/build"

mkdir -p "$DEPLOYMENT_BUILD_DIR"
cp "$TARGET_JAR" "$DEPLOYMENT_BUILD_DIR"

# 5. Print success message
print_message "Setup completed successfully!"

