
output "workspace-name" {
  description = "id of workspace"
  value = terraform.workspace
}


output "configs" {
  description = "id of workspace"
  value = local.env
}

