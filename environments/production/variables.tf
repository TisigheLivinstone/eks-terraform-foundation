variable "project_name" {
  type    = string
  default = "livinstone-infra"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
variable "application_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}
variable "application_min_size" {
  type    = number
  default = 1
}
variable "application_max_size" {
  type    = number
  default = 10
}
variable "application_desired_size" {
  type    = number
  default = 1
}
