# タスク定義の作成
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = local.app # タスク定義の名前
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"] # コンテナの実行環境
  # ここで使用されている IAM ロールについては後ほど作成(タスク実行ロール、タスクロール)
  execution_role_arn = aws_iam_role.ecs.arn
  task_role_arn      = aws_iam_role.ecs_task.arn
  # ダミーコンテナの設定(コンテナの設定、コンテナのログの設定、環境変数)
  container_definitions = <<CONTAINERS
[
  {
    "name": "${local.app}",
    "image": "medpeer/health_check:latest",
    "portMappings": [
      {
        "hostPort": 8080,
        "containerPort": 8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_log_group.name}",
        "awslogs-region": "${local.region}",
        "awslogs-stream-prefix": "${local.app}"
      }
    },
    "environment": [
      {
        "name": "NGINX_PORT",
        "value": "8080"
      },
      {
        "name": "HEALTH_CHECK_PATH",
        "value": "/health_checks"
      }
    ]
  }
]
CONTAINERS
}

# サービスの作成
resource "aws_ecs_service" "ecs_service" {
  name            = local.app
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2 # 実行するタスクの数(2つのAZにコンテナを分散するため)
  network_configuration {
    subnets         = module.vpc.private_subnets  # タスクの起動を許可するサブネット
    security_groups = [aws_security_group.ecs.id] # タスクに紐づけるセキュリティーグループ
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = local.app
    container_port   = 8080
  }
  depends_on = [aws_lb_listener_rule.alb_listener_rule]
}

# クラスタの作成
resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.app
}
