variable "snapshot_arn" {
  type        = string
  description = "ARN of MySQL DB with the schema intalled"
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type        = list(string)
  description = "The list of subnets to host DB instance"
}

variable "db_paramters" {
  type        = map(string)
  description = "Map of DB configuration parameters for MySQL DB"
}
