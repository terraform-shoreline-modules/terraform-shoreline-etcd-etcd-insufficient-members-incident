resource "shoreline_notebook" "etcd_insufficient_members_incident" {
  name       = "etcd_insufficient_members_incident"
  data       = file("${path.module}/data/etcd_insufficient_members_incident.json")
  depends_on = [shoreline_action.invoke_etcd_monitoring,shoreline_action.invoke_add_member_to_cluster]
}

resource "shoreline_file" "etcd_monitoring" {
  name             = "etcd_monitoring"
  input_file       = "${path.module}/data/etcd_monitoring.sh"
  md5              = filemd5("${path.module}/data/etcd_monitoring.sh")
  description      = "Insufficient resources like CPU, memory, or disk space on one or more Etcd members can cause them to become unresponsive or crash, leading to a reduced cluster size."
  destination_path = "/agent/scripts/etcd_monitoring.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "add_member_to_cluster" {
  name             = "add_member_to_cluster"
  input_file       = "${path.module}/data/add_member_to_cluster.sh"
  md5              = filemd5("${path.module}/data/add_member_to_cluster.sh")
  description      = "Increase the number of Etcd members: In order to maintain the required odd number of members, additional Etcd members can be added to the cluster. This can be done manually or through automation."
  destination_path = "/agent/scripts/add_member_to_cluster.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_etcd_monitoring" {
  name        = "invoke_etcd_monitoring"
  description = "Insufficient resources like CPU, memory, or disk space on one or more Etcd members can cause them to become unresponsive or crash, leading to a reduced cluster size."
  command     = "`chmod +x /agent/scripts/etcd_monitoring.sh && /agent/scripts/etcd_monitoring.sh`"
  params      = ["MEMORY_THRESHOLD","DISK_THRESHOLD","CPU_THRESHOLD","MEMBER_NAME","ETCD_ENDPOINTS"]
  file_deps   = ["etcd_monitoring"]
  enabled     = true
  depends_on  = [shoreline_file.etcd_monitoring]
}

resource "shoreline_action" "invoke_add_member_to_cluster" {
  name        = "invoke_add_member_to_cluster"
  description = "Increase the number of Etcd members: In order to maintain the required odd number of members, additional Etcd members can be added to the cluster. This can be done manually or through automation."
  command     = "`chmod +x /agent/scripts/add_member_to_cluster.sh && /agent/scripts/add_member_to_cluster.sh`"
  params      = ["NEW_MEMBER_IP","MEMBER_NAME","NEW_MEMBER_NAME","ETCD_ENDPOINTS"]
  file_deps   = ["add_member_to_cluster"]
  enabled     = true
  depends_on  = [shoreline_file.add_member_to_cluster]
}

