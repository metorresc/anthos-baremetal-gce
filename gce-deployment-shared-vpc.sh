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

source variables.env
set -eu

echo ""
echo "Preparing to execute with the following values:"
echo "==================================================="
echo "Project ID: $PROJECT_ID"
echo "Region for Deployment: $REGION"
echo "Zone for Deployment: $ZONE"
echo "Network Configuration: $NW_TYPE"
echo "Zone for Deployment: $ZONE"
echo "VM Type: $MACHINE_TYPE"
echo "==================================================="
echo ""
echo "Continuing in 5 seconds. Ctrl+C to cancel"
sleep 5

# Creating Anthos Workstation
echo ""
echo "Creating Anthos Workstation" 
gcloud compute instances create $ABM_WS \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags abm-gce \
        --service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type e2-standard-2

# Creating Anthos Control Plane # 1
echo ""
echo "Creating Anthos Control Plane # 1" 
gcloud compute instances create $ABM_CP1 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags abm-gce \
        --service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

# Creating Anthos Control Plane # 2
echo ""
echo "Creating Anthos Control Plane # 2" 
gcloud compute instances create $ABM_CP2 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags abm-gce \
        --service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

# Creating Anthos Control Plane # 3
echo ""
echo "Creating Anthos Control Plane # 3" 
gcloud compute instances create $ABM_CP3 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags abm-gce \
        --service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

# Creating Anthos Worker Node # 1
echo ""
echo "Creating Anthos Worker Node # 1"
gcloud compute instances create $ABM_WN1 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags abm-gce \
        --service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

# Creating Anthos Worker Node # 2
echo ""
echo "Creating Anthos Worker Node # 2" 
gcloud compute instances create $ABM_WN2 \
        --image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
        --zone=$ZONE \
        --boot-disk-size 200G \
        --boot-disk-type pd-ssd \
        --can-ip-forward \
        --subnet=projects/$SHARED_VPC_PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_NAME \
        --no-address \
        --tags abm-gce \
        --service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
        --scopes cloud-platform \
        --machine-type $MACHINE_TYPE

echo ""
echo "Testing if the VMs were created correctly"
gcloud compute instances list

echo ""
echo "========================="
echo "VMs deployment completed"
echo "========================="
