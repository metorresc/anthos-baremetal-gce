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

i=4
apt-get -qq update > /dev/null
apt-get -qq install -y jq > /dev/null
set -x
ip link add vxlan0 type vxlan id 42 dev ens4 dstport 0
for ip in ${IPs[@]}; do
    if [ "\$ip" != "10.100.0.33" ]; then
        bridge fdb append to 00:00:00:00:00:00 dst \$ip dev vxlan0
    fi
done
ip addr add 10.200.0.$i/24 dev vxlan0
ip link set up dev vxlan0
systemctl stop apparmor.service
systemctl disable apparmor.service