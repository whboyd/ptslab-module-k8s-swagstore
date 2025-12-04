output "kubeconfig_path" {
  value = resource.kubernetes_cluster.k8s.kube_config.path
}