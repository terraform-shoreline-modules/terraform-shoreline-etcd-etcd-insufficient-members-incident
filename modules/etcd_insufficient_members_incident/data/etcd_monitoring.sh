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