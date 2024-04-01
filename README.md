# memo_app


## 実行手順
0. PostgreSQLでデータベースを構築(PostgreSQL 15.6で動作確認済み)
1. 以下のdatabase.ymlのyourの部分を設定
```
production:
  dbname: your_production_database_name
  user: your_production_username
  password: your_production_password
  host: your_production_host
  port: your_production_port
```
2. このレポジトリーをクローンする

```git clone -b https://github.com/kutimiti1234/memo_app.git```

2.このREADMEがあるディレクトリで以下を実行。
```bundle install```

3.```bundle exec ruby app.rb```で実行




