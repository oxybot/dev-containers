#!/bin/bash

# This script is used to test the vulnerabilities of the image.
# It will build the image and then use a tool to scan for vulnerabilities.

# Build the image
docker build -t dev-env:local .

# Install trivy if not already installed
if ! command -v trivy &> /dev/null
then
    echo "Trivy could not be found, installing..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi

# Scan the image for vulnerabilities
echo "Scanning the image for vulnerabilities..."
trivy image --severity HIGH,CRITICAL dev-env:local --ignore-unfixed --format table --output vulnerabilities.txt

echo "Vulnerability scan completed. Results saved to vulnerabilities.txt"
