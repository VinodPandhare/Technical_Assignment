variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "db_name" {
  description = "RDS Database Name"
  default     = "vineetdb"
}

variable "db_password" {
  description = "RDS Database Password"
  default     = "vineet123"
}
