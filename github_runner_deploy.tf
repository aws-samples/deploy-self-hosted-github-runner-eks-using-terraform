
resource "helm_release" "actions_runner_controller" {
  name             = "arc-controller"
  namespace        = "arc-systems"
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set-controller"
  version          = "0.9.3"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  depends_on       = [module.eks_blueprints_addon, null_resource.deploy_node_class, null_resource.deploy_node_pool]

}
locals {
  runner_sets = {
    for runner, runner_config in var.runner_set_parameters : runner => {
      name = "${runner}-runner-set"
      values = templatefile("runner_set.tpl", {
        githubConfigUrl = runner_config.githubConfigUrl
        minRunners      = runner_config.minRunners
        maxRunners      = runner_config.maxRunners
        node-pool-name  = runner_config.node-pool-name
        cpu             = runner_config.cpu
        memory          = runner_config.memory
      })
    }
  }
}

resource "time_sleep" "delay_before_runner_sets_destroy" {
  destroy_duration = "45s"
  create_duration  = "1s"
  depends_on       = [module.eks_blueprints_addon, helm_release.actions_runner_controller]
}

resource "helm_release" "runner_sets" {
  for_each         = local.runner_sets
  name             = each.value.name
  namespace        = "arc-runners"
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set"
  version          = "0.9.3"
  create_namespace = true
  values           = [each.value.values]
  set {
    name  = "githubConfigSecret.github_token"
    value = data.aws_secretsmanager_secret_version.pat.secret_string
  }
  depends_on = [module.eks_blueprints_addon, helm_release.actions_runner_controller, time_sleep.delay_before_runner_sets_destroy]
}

data "aws_secretsmanager_secret_version" "pat" {
  secret_id = var.pat_secret_name
}
