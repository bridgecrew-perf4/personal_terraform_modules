# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the repository"
  type = string
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These have reasonable defaults
# ---------------------------------------------------------------------------------------------------------------------

variable "encryption_type" {
  description = "(Optional) The encryption type to use for the repository. Valid values are AES256 or KMS. Defaults to AES256."
  type = string
  default = null
}

variable "image_tag_mutability" {
  description = "(Optional) The tag mutability setting for the repository. Must be one of: Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE. or IMMUTABLE. Defaults to MUTABLE."
  type = string
  default = null
}

variable "scan_on_push" {
  description = "(Optional) Configuration block that defines image scanning configuration for the repository. By default, image scanning must be manually triggered. See the ECR User Guide for more information about image scanning."
  type = bool
  default = null
}