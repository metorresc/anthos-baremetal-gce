# anthos-baremetal-gce by mtorresc@google.com

## Copyright 2021 Google LLC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

## Clone this repository to begin

     git clone https://github.com/manueltorresc/anthos-baremetal-gce.git

## Set all the deployment parameters on the variables.env file using nano or vim

     nano variables.env

or

     vim variables.env

## This script must be executed from Cloud Shell
For GCE Infra deployment please execute

     chmod +x deployment-infra.sh
     ./deployment-infra.sh

For Anthos Software deployment on GCE please execute
     
     chmod +x deployment-anthos.sh
     ./deployment-anthos.sh
