# -------------------
# -- AWS ACCOUNT INFO
# -------------------

variable "aws_account_id" {
  description = "Your AWS Account Id"
  type = string
  default = null
}

variable "aws_region" {
  description = "AWS Region to apply resources to"
  type= string
  default = null
}

# ------------------
# -- AWS CLOUD WATCH
# ------------------
variable "cloud_watch_log_group" {
  description = "Name of your cloud watch log group"
  type = string
  default = null
}

variable "cloud_watch_log_stream" {
  description = "Name of your cloud watch log stream"
  type = string
  default = null
}


# ------------------
# -- AWS CLOUD WATCH
# ------------------
variable "vpc_id" {
  description = "The VPC Ids to deploy to"
  type = string
  default = null
}

variable "subnet_ids" {
  description = "The subnet IDS to deploy to"
  type = list(string)
  default = null
}


# --------------
# -- ECS CLUSTER
# --------------
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ecs_cluster_name" {
  description = "The AWS ECS Cluster Name"
  type = string
  default = null
}


# --------------
# -- ECS SERVICE
# --------------
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ecs_service_name" {
  description = "The ECS Service Name"
  type = string
  default = null
}

variable "ecs_subnets" {
  description = "Subnets used for ECS service"
  type = list(string)
  default = null
}

variable "ecs_security_groups" {
  description = "Security groups used for ECS service"
  type = list(string)
  default = null
}

variable "alb_target_group_arn" {
  description = "Target group arn from alb for ECS service"
  type = string
  default = null
}

# ---------------
# -- ECS TASK DEF
# ---------------
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------


# -- Container definitions
variable "task_definition_template_file" {
  description = "Relative path from module to your task definition"
  type = string
  default = null
}

variable "container_definitions" {
  description = "Stringified file for your container definitions"
  type = string
  default = null
}

variable "task_port" {
  description = "Port to run your task on for ECS service"
  type = number
  default = null
}

variable "task_protocol" {
  description = "Protocol to run your task on for ECS service"
  type = string
  default = null
}

variable "task_definition_image_url" {
  description = "Task definition Image URL"
  type = string
  default = null
}

variable "desired_count" {
  description = "Number of running tasks desired for your service"
  type = number
  default = null
}

variable "launch_type" {
  description = "AWS ECS Launch type - FARGATE OR EC2"
  type = string
  default = null
}

variable "scheduling_strategy" {
  description = "The scheduling strategy to use for the service."
  type = string
  default = null
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  type = string
  default = null
}


variable "cpu" {
  description = "CPU for ECS service"
  type = string
  default = null
}

variable "memory" {
  description = "Memory for ECS Service"
  type = string
  default = null
}

