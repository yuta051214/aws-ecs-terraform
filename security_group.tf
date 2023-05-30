# ALB(Application Load Balancer)
resource "aws_security_group" "alb" {
  name        = "${local.app}-alb"
  description = "For ALB."
  vpc_id      = module.vpc.vpc_id

  # インバウンド(only HTTP)
  ingress {
    description = "Allow HTTP from ALL."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # アウトバウンド(all)
  egress {
    description = "Allow all to outbound."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.app}-alb"
  }
}

# ECS(Elastic Container Service)
resource "aws_security_group" "ecs" {
  name        = "${local.app}-ecs"
  description = "For ECS."
  vpc_id      = module.vpc.vpc_id

  # アウトバウンド(all)
  egress {
    description = "Allow all to outbound."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.app}-ecs"
  }
}

# ECS のインバウンド(only from ALB)
resource "aws_security_group_rule" "ecs_from_alb" {
  description              = "Allow 8080 from Security Group for ALB."
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs.id
}
