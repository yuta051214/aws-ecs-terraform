# ALB(Application Load Balancer)の作成
resource "aws_lb" "alb" {
  name               = "${local.app}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets
}

# ALBリスナーの作成
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

# ALBリスナーのルール(ターゲットグループ に トラフィック をルーティング)
resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

# ターゲットグループ(ECS on Fargate で稼働させるコンテナ群)
resource "aws_lb_target_group" "target_group" {
  name        = "${local.app}-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    healthy_threshold = 3
    interval          = 30
    path              = "/health_checks"
    protocol          = "HTTP"
    timeout           = 5
  }
}
