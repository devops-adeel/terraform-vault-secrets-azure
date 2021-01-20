variable "group_ids" {
  description = "List of Vault Identity Group Member IDs"
  type        = list(any)
  default     = []
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type = string
}
