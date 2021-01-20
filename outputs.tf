output "vault_identity_group" {
  description = "JSON data of the Vault Identity Group, including list of member entities"
  value       = data.vault_identity_group.default.data_json
}
