resource "helm_release" "rancher" {
  provider   = helm

  name       = "rancher"
  repository = "${var.rancher_helm_repo}"
  chart      = "rancher"
  create_namespace = true
  namespace  = "cattle-system"

  set {
    name = "hostname"
    value = "${var.rancher_uri}"
  }
  set {
    name = "ingress.tls.source"
    value = "secret"
  }
}

resource "rancher2_app_v2" "cost-analyzer" {
  depends_on = [ helm_release.rancher ]

  provider = rancher2.admin
  cluster_id = "${var.cluster_id}"
  name = "cost-analyzer"
  namespace = "kubecost"
  repo_name = "rancher-partner-charts"
  chart_name = "cost-analyzer"
  values = file("cost-analyzer.yaml")
}
