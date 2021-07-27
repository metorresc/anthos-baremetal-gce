#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source ./variables.env
set -eu

echo ""
echo "Preparing to execute with the following values:"
echo "==================================================="
echo "Project ID: $PROJECT_ID"
echo "Region for Deployment: $REGION"
echo "Zone for Deployment: $ZONE"
#echo "Shared VPC Project ID: $SHARED_VPC_PROJECT_ID"
#echo "Shared Subnet Name: $SUBNET_NAME"
echo "Zone for Deployment: $ZONE"
echo "VM Type: $MACHINE_TYPE"
echo "==================================================="
echo ""
echo "Continuing in 10 seconds. Ctrl+C to cancel"
sleep 10

# Creating Anthos Workstation
echo "Creating Anthos Workstation" 
gcloud compute instances create $ABM_WS \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
 #      Comment the following line only if you are using a Shared VPC
 #       --network default \
 #      Comment the following line only if you are using The Default VPC
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags http-server,https-server \
        --service-account=baremetal-gcr@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type e2-standard-2

# Creating Anthos Control Plane # 1
echo "Creating Anthos Control Plane # 1" 
gcloud compute instances create $ABM_CP1 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
 #      Comment the following line only if you are using a Shared VPC
 #       --network default \
 #      Comment the following line only if you are using The Default VPC        
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags http-server,https-server \
        --service-account=baremetal-gcr@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

# Creating Anthos Control Plane # 2
echo "Creating Anthos Control Plane # 2" 
gcloud compute instances create $ABM_CP2 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
 #      Comment the following line only if you are using a Shared VPC
 #       --network default \
 #      Comment the following line only if you are using The Default VPC        
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags http-server,https-server \
        --service-account=baremetal-gcr@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

# Creating Anthos Control Plane # 3
echo "Creating Anthos Control Plane # 3" 
gcloud compute instances create $ABM_CP3 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
 #      Comment the following line only if you are using a Shared VPC
 #       --network default \
 #      Comment the following line only if you are using The Default VPC        
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags http-server,https-server \
        --service-account=baremetal-gcr@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

# Creating Anthos Worker Node # 1
echo "Creating Anthos Worker Node # 1"
gcloud compute instances create $ABM_WN1 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
 #      Comment the following line only if you are using a Shared VPC
 #       --network default \
 #      Comment the following line only if you are using The Default VPC        
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags http-server,https-server \
        --service-account=baremetal-gcr@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

# Creating Anthos Worker Node # 2
echo "Creating Anthos Worker Node # 2" 
gcloud compute instances create $ABM_WN2 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
 #      Comment the following line only if you are using a Shared VPC
 #       --network default \
 #      Comment the following line only if you are using The Default VPC        
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags http-server,https-server \
        --service-account=baremetal-gcr@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

echo "Testing if the VMs were created correctly"
gcloud compute instances list
