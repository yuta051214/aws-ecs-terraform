# コンテナのログ出力先として CloudWatch Logs にロググループを作成
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/ecs/${local.app}"
  retention_in_days = 1 # ログの保存期間
}
