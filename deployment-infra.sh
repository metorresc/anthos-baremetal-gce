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

echo ""
echo "Preparing to execute ABM on GCE Deployment Script"
echo "==================================================="
echo ""
echo "Continuing in 10 seconds. Ctrl+C to cancel"
sleep 10

source ./variables.env
set -xeu

# Enable APIs and Creating Service Account
echo "Enabling required APIs and Service Accounts"
./landing-zone-security.sh

# Enable APIs and Creating Service Account
echo "Creating VMs"
./landing-zone-infra.sh

echo ""
echo "Deployment Completed"
echo ""
echo 'To continue setting up Anthos please run "./deployment-anthos.sh"'
echo ""

