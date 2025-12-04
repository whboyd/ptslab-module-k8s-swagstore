output "kubeconfig_path" {
  value = resource.kubernetes_cluster.k8s.kube_config.path
  description = "Path to the kubeconfig file"
}

output "network_id" {
  value = resource.network.main.meta.id
  description = "ID of the network used by the cluster"
}