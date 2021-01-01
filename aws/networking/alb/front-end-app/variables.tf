# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "alb_name" {
  description = "The name to use for this ALB"
  type = string
  default = null
}

variable "subnet_ids" {
  description = "The subnet IDS to deploy to"
  type = list(string)
  default = null
}

variable "target_type" {
  description = "The type of target that you must specify when registering targets with this target group"
  type = string
  default = null
}

variable "internal" {
  description = "ALB internal in VPC vs external internet facing"
  type = bool
  default = null
}


variable "acm_domain_certificate" {
  description = "Domain of the AWS ECM Certificate"
  type = string
  default = null
}


