data "aws_vpc" "default" {
  count = var.vpc_id == null ? 1 : 0
  default = true
}

data "aws_subnet_ids" "default" {
  count = var.subnet_ids == null ? 1 : 0
  vpc_id = local.vpc_id
}

locals {
  vpc_id = (
  var.vpc_id == null
  ? data.aws_vpc.default[0].id
  : var.vpc_id
  )

  subnet_ids = (
  var.subnet_ids == null
  ? data.aws_subnet_ids.default[0].ids
  : var.subnet_ids
  )
}