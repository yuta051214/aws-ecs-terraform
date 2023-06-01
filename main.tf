# main.tf では、Terraform のバックエンドの設定を行なっています。ここで指定された S3 バケット内にある tfstate ファイルと DynamoDB を参照してインフラストラクチャーを管理しています。
# main.tf のコードを削除すると、現在のアーキテクチャの状態を取得できなくなり、正常にリソースを削除することができません。

terraform {
  backend "s3" {
    bucket         = "aws-ecs-terraform-tfstate-test"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "aws-ecs-terraform-tfstate-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
  }
}

provider "aws" {
  region = local.region
}
