variable "alert_email" {
  description = "Email address that receives critical infrastructure alerts"
  type        = string
}

variable "db_multi_az" {
  description = "Whether the portal database uses a Multi-AZ deployment"
  type        = bool
}