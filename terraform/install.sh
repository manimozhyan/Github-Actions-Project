#!/bin/bash

set -e

echo "Updating packages..."
sudo apt update -y
sudo apt upgrade -y

echo "Installing required packages..."
sudo apt install -y \
    unzip \
    curl \
    wget \
    git \
    ca-certificates \
    gnupg \
    lsb-release

# --------------------------------------------------
# Java 17 Temurin
# --------------------------------------------------

echo "Installing Java 17 Temurin..."

sudo mkdir -p /etc/apt/keyrings

wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public \
  | sudo gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg

echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/adoptium.list

sudo apt update -y
sudo apt install -y temurin-17-jdk

java -version

# --------------------------------------------------
# Docker
# --------------------------------------------------

echo "Installing Docker..."

sudo apt install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

docker --version

# --------------------------------------------------
# kubectl
# --------------------------------------------------

echo "Installing kubectl..."

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm -f kubectl

kubectl version --client

# --------------------------------------------------
# Trivy
# --------------------------------------------------

echo "Installing Trivy..."

sudo apt install -y wget apt-transport-https gnupg

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt update -y
sudo apt install -y trivy

trivy --version

# --------------------------------------------------
# SonarQube
# --------------------------------------------------

echo "Installing SonarQube..."

sudo mkdir -p /opt/sonarqube

sudo docker pull sonarqube:lts-community

sudo docker run -d \
  --name sonarqube \
  --restart unless-stopped \
  -p 9000:9000 \
  sonarqube:lts-community

echo "SonarQube container started."

# --------------------------------------------------
# Final verification
# --------------------------------------------------

echo "======================================"
echo "Installation completed!"
echo "======================================"

echo "Java:"
java -version

echo "Docker:"
docker --version

echo "Kubectl:"
kubectl version --client

echo "Trivy:"
trivy --version

echo "SonarQube:"
sudo docker ps --filter name=sonarqube

echo "SonarQube URL:"
echo "http://<EC2-PUBLIC-IP>:9000"