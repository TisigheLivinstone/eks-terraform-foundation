variable "project_name" {
  type    = string
  default = "livinstone-infra"
}

variable "environment" {
  type    = string
  default = "staging"
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
  default = "10.2.0.0/16"
}
variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.2.1.0/24", "10.2.2.0/24"]
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.2.101.0/24", "10.2.102.0/24"]
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
  default = 4
}
variable "application_desired_size" {
  type    = number
  default = 1
}
