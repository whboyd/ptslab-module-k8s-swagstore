output "kubeconfig_path" {
  value = resource.kubernetes_cluster.k8s.kube_config.path
}

output "network_id" {
  value = resource.network.main.meta.id
}