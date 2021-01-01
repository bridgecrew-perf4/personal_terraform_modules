// ------------ aws roles for ecs
resource "aws_iam_role" "execution_role" {
  name = "${var.ecs_service_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#example-of-using-data-source-for-assume-role-policy
# Assume role policy first, then attach other policies
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "AmazonECS_FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
data "aws_iam_policy" "AmazonEC2ContainerRegistryFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "CloudWatchLogsFullAccess" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# https://stackoverflow.com/questions/45002292/terraform-correct-way-to-attach-aws-managed-policies-to-a-role
resource "aws_iam_role_policy_attachment" "aws_ecs_task_execution_role_attach" {
  role = aws_iam_role.execution_role.name
  policy_arn = data.aws_iam_policy.AmazonECS_FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "aws_ec2_task_execution_role_attach" {
  role = aws_iam_role.execution_role.name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "aws_cloud_watch_task_execution_role_attach" {
  role = aws_iam_role.execution_role.name
  policy_arn = data.aws_iam_policy.CloudWatchLogsFullAccess.arn
}






// ----------- aws cloud watch
resource "aws_cloudwatch_log_group" "ecs" {
  name = var.cloud_watch_log_group
  tags = {
    Environment = "production"
  }
}

resource "aws_cloudwatch_log_stream" "ecs" {
  name = var.cloud_watch_log_stream
  log_group_name = aws_cloudwatch_log_group.ecs.name
}

resource "aws_ecs_cluster" "production_personal" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_service" "personal_service" {
  name = var.ecs_service_name
  cluster = aws_ecs_cluster.production_personal.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count = var.desired_count
  launch_type = var.launch_type
  scheduling_strategy = var.scheduling_strategy
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    # https://forums.aws.amazon.com/thread.jspa?threadID=217089
    container_name = "${var.ecs_service_name}-task"
    container_port = var.task_port
  }
  network_configuration {
    subnets = local.subnet_ids
    security_groups = var.ecs_security_groups
    assign_public_ip = true
  }
  depends_on = [aws_ecs_task_definition.task_definition, aws_ecs_cluster.production_personal]
}

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = var.container_definitions
  family = var.ecs_service_name
  task_role_arn = aws_iam_role.execution_role.arn
  execution_role_arn = aws_iam_role.execution_role.arn
  network_mode = var.network_mode
  requires_compatibilities = [var.launch_type]
  cpu = var.cpu
  memory = var.memory

}


