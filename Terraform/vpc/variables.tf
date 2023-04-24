variable "vpc_cidr" {
  type = string
}

variable "private_subnet_cidr_blocks" {
  type = list(any)
}

variable "public_subnet_cidr_blocks" {
  type = list(any)
}

variable "availability_zones" {
  type = list(any)
}