

#!/bin/bash



# Set variables
MEMBER_NAME=${NEW_MEMBER_NAME}

NEW_MEMBER_IP=${NEW_MEMBER_IP}

ETCD_ENDPOINTS=${ETCD_ENDPOINTS}



# Add new member to cluster

etcdctl --endpoints=$ETCD_ENDPOINTS member add $MEMBER_NAME --peer-urls=http://$NEW_MEMBER_IP:2380



# Verify cluster health

etcdctl --endpoints=$ETCD_ENDPOINTS cluster-health