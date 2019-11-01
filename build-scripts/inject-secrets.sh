#!/bin/bash
mkdir ~/.kube
mv ./build-scripts/kubeconfig ~/.kube/config
 
#decrypt the large secrets
openssl aes-256-cbc -K $encrypted_a4d61efd9b88_key -iv $encrypted_a4d61efd9b88_iv -in large-secrets.txt.enc -out build-scripts/large-secrets.txt -d
 
# run the script to get the secrets as environment variables
source ./build-scripts/large-secrets.txt
export $(cut -d= -f1 ./build-scripts/large-secrets.txt)
 
 
# Set kubernetes secrets
./kubectl config set clusters.datatrack.io.certificate-authority-data $CERTIFICATE_AUTHORITY_DATA
./kubectl config set users.datatrack.io.client-certificate-data "$CLIENT_CERTIFICATE_DATA"
./kubectl config set users.datatrack.io.client-key-data "$CLIENT_KEY_DATA"
./kubectl config set users.datatrack.io.password "$KUBE_PASSWORD"
./kubectl config set users.datatrack.io.net-basic-auth.password "$KUBE_PASSWORD"
 
# set AWS secrets
mkdir ~/.aws
touch ~/.aws/credentials
echo '[default]' >> ~/.aws/credentials
echo "aws_access_key_id = $AWS_KEY">> ~/.aws/credentials
echo "aws_secret_access_key = $AWS_SECRET_KEY" >> ~/.aws/credentials
 
# set AWS region
touch ~/.aws/config
echo '[default]' >> ~/.aws/config
echo "output = json">> ~/.aws/config
echo "region = {your-aws-region}" >> ~/.aws/config