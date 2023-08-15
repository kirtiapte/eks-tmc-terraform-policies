variable "tmc_host" {
  type        = string
  description = "TMC Host"
}

variable "vmw_api_token" {
  type        = string
  sensitive   = true
  description = "TMC API Token"
}
