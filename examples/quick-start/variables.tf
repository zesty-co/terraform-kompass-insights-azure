variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string
  nullable    = false
}

variable "cluster_resource_group_name" {
  description = "The name of the Resource Group for the Kubernetes cluster"
  type        = string
  nullable    = false
}
