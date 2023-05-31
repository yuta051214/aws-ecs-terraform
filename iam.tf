# IAMポリシー: AWSリソースにアクセスするための権限設定。
# IAMロール: AWSリソースに付与するもので、実態はIAMポリシーをまとめたもの。
# ECSのタスクが、IAMロール(タスクロール)を一時的に引き受け(assume)、その権限内でAWSリソースに対して操作を行うことができる。IAMロール(タスクロール)に設定されたIAMポリシーにより、タスクがアクセスできるAWSリソースや実行できるアクションが制限される。
# AssumeRoleとは、特定のIAMロールを一時的に引き受ける(assume)ことを可能にするAWS Security Token Service (STS) のAPIで、この機能により、IAMロールに設定された権限でAWSリソースにアクセスできるようになります。

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${local.app}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs" {
  name               = "${local.app}-ecs"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_basic" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
