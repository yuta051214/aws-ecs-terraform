# リポジトリの作成
resource "aws_ecr_repository" "ecr_repository" {
  name                 = local.app
  image_tag_mutability = "IMMUTABLE" # image tag の上書きを禁止
  force_delete         = true

  # image の脆弱性を診断する
  image_scanning_configuration {
    scan_on_push = true
  }
}

# ライフサイクルに関するポリシー
resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  repository = aws_ecr_repository.ecr_repository.name

  # image の数が数が30を超えた場合、古い順に削除する(= expireとする)
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
