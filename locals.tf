# ローカル変数を設定
locals {
  name   = replace(basename(path.cwd), "_", "-") # カレントディレクトリの名前(aws-ecs-terraform)を取得し設定("_" は "-"" に変換)
  region = "ap-northeast-1"                      # 東京リージョン
  app    = "go-simple-server"                    # デプロイするアプリ名
}
