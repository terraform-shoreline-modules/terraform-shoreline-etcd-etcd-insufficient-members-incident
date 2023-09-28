
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Etcd insufficient Members incident.
---

The Etcd insufficient Members incident type refers to an issue where the Etcd cluster has an insufficient number of members. Etcd is a distributed key-value store used for shared configuration and service discovery. In order to maintain high availability and fault tolerance, the cluster should have an odd number of members. When the number of members falls below the minimum required, it can result in service outages and other disruptions. This incident type requires immediate attention to restore the service to normal operation.

### Parameters
```shell
export ETCD_ENDPOINTS="PLACEHOLDER"

export NEW_MEMBER_IP="PLACEHOLDER"

export CPU_THRESHOLD="PLACEHOLDER"

export MEMORY_THRESHOLD="PLACEHOLDER"

export MEMBER_NAME="PLACEHOLDER"

export DISK_THRESHOLD="PLACEHOLDER"

export NEW_MEMBER_NAME="PLACEHOLDER"
```

## Debug

### Check the status of the Etcd cluster
```shell
systemctl status etcd
```

### View the Etcd log to check for any errors or warnings
```shell
journalctl -u etcd
```

### Check the number of Etcd members
```shell
etcdctl member list
```

### Check the health of the Etcd cluster
```shell
etcdctl cluster-health
```

### Check the amount of available disk space on the Etcd nodes
```shell
df -h / | tail -n 1 | awk '{print $5}' | sed 's/%//'
```

### Check the memory usage on the Etcd nodes
```shell
free -m
```

### Check the CPU usage on the Etcd nodes
```shell
top
```

### Verify that the Etcd configuration has an odd number of members
```shell
cat /etc/etcd/etcd.conf | grep ETCD_INITIAL_CLUSTER
```

### Insufficient resources like CPU, memory, or disk space on one or more Etcd members can cause them to become unresponsive or crash, leading to a reduced cluster size.
```shell
bash

#!/bin/bash



# Define variables

ETCD_ENDPOINT=${ETCD_ENDPOINTS}

MEMBER_NAME=${MEMBER_NAME}

CPU_THRESHOLD=${CPU_THRESHOLD}

MEMORY_THRESHOLD=${MEMORY_THRESHOLD}

DISK_THRESHOLD=${DISK_THRESHOLD}



# Get CPU usage

CPU_USAGE=$(ssh $ETCD_ENDPOINT "top -bn1 | grep $MEMBER_NAME | awk '{print $9}'")



# Get memory usage

MEMORY_USAGE=$(ssh $ETCD_ENDPOINT "free -m | grep Mem | awk '{print $3/$2 * 100.0}'")



# Get disk usage

DISK_USAGE=$(ssh $ETCD_ENDPOINT "df -h / | tail -n 1 | awk '{print $5}' | sed 's/%//'")



# Check if any usage is above the threshold

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) ))

then

    echo "CPU usage for $MEMBER_NAME on $ETCD_ENDPOINT is above the threshold of $CPU_THRESHOLD%: $CPU_USAGE%"

fi



if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) ))

then

    echo "Memory usage for $MEMBER_NAME on $ETCD_ENDPOINT is above the threshold of $MEMORY_THRESHOLD%: $MEMORY_USAGE%"

fi



if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) ))

then

    echo "Disk usage for $MEMBER_NAME on $ETCD_ENDPOINT is above the threshold of $DISK_THRESHOLD%: $DISK_USAGE%"

fi


```

## Repair

### Increase the number of Etcd members: In order to maintain the required odd number of members, additional Etcd members can be added to the cluster. This can be done manually or through automation.
```shell


#!/bin/bash



# Set variables
MEMBER_NAME=${NEW_MEMBER_NAME}

NEW_MEMBER_IP=${NEW_MEMBER_IP}

ETCD_ENDPOINTS=${ETCD_ENDPOINTS}



# Add new member to cluster

etcdctl --endpoints=$ETCD_ENDPOINTS member add $MEMBER_NAME --peer-urls=http://$NEW_MEMBER_IP:2380



# Verify cluster health

etcdctl --endpoints=$ETCD_ENDPOINTS cluster-health


```