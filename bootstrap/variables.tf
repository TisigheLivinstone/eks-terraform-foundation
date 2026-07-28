variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Used as a prefix for all resources"
  type        = string
  default     = "livinstone-infra"
}
