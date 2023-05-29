terraform {
  backend "s3" {
    bucket = "aws-ecs-terraform-tfstate-test"
    key = "terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "aws-ecs-terraform-tfstate-locking"
    encrypt = true
  }
}
