resource "aws_ecr_repository" "medusa" {
  name = "medusa-backend"
}

resource "aws_ecs_cluster" "medusa" {
  name = "medusa-cluster"
}

resource "aws_iam_role" "ecs_task_exec_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_attach" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "medusa" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
  container_definitions    = jsonencode([
    {
      name  = "medusa",
      image = "${aws_ecr_repository.medusa.repository_url}:${var.image_tag}",
      essential = true,
      portMappings = [
        {
          containerPort = 9000,
          hostPort      = 9000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "medusa" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa.id
  task_definition = aws_ecs_task_definition.medusa.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnet_ids
    assign_public_ip = true
    security_groups = []  # You can use existing one or create a web sg
  }
}
