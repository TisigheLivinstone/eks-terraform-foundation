variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "system_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "system_desired_size" {
  type    = number
  default = 2
}

variable "system_min_size" {
  type    = number
  default = 2
}

variable "system_max_size" {
  type    = number
  default = 4
}

variable "application_instance_types" {
  type    = list(string)
  default = ["m5.large"]
}

variable "application_desired_size" {
  type    = number
  default = 2
}

variable "application_min_size" {
  type    = number
  default = 1
}

variable "application_max_size" {
  type    = number
  default = 10
}

variable "tags" {
  type    = map(string)
  default = {}
}
