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
echo "Service Account Name: $SERVICE_ACCOUNT"
echo "==================================================="
echo ""
echo "Continuing in 5 seconds. Ctrl+C to cancel"
sleep 5

check_svc_acct=`gcloud iam service-accounts list --filter "$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" | grep "$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" | wc -l | tr -d ' '`
if [ "$check_svc_acct" = "0" ];then 
  gcloud iam service-accounts create $SERVICE_ACCOUNT
else
  echo "Service Account already exists. Skipping"
fi

# Enable the required APIs
echo ""
echo "Enabling APIs"
gcloud services enable \
    anthos.googleapis.com \
    anthosgke.googleapis.com \
    cloudresourcemanager.googleapis.com \
    container.googleapis.com \
    gkeconnect.googleapis.com \
    gkehub.googleapis.com \
    serviceusage.googleapis.com \
    stackdriver.googleapis.com \
    monitoring.googleapis.com \
    logging.googleapis.com

# Binding permissions to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/gkehub.connect"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/gkehub.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/logging.logWriter"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/monitoring.metricWriter"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/monitoring.dashboardEditor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/stackdriver.resourceMetadata.writer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountKeyAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.osLogin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/osconfig.serviceAgent"

echo ""
echo " Creating Firewall Rules for Control Plane"
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-controlplane-10250 --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=tcp:10250
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-controlplane-443 --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=tcp:443
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-controlplane-8443 --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=tcp:8443
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-controlplane-8676 --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=tcp:8676
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-controlplane-15017 --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=tcp:15017

echo ""
echo " Creating Firewall Rules for WorkerNodes"
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-workernodes-tcp --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=tcp:1-65535
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-workernodes-udp --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=udp:1-65535
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-workernodes-icmp --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=icmp
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-workernodes-sctp --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=sctp
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-workernodes-esp --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=esp
gcloud compute --project=$PROJECT_ID firewall-rules create abm-gce-workernodes-ah --direction=INGRESS --network=$VPC_NAME --action=ALLOW --target-tags=abm-gce --source-ranges=$IP_RANGE --rules=ah