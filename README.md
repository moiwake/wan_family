# Wan-Family
![wan-family-app com_ (2)](https://github.com/moiwake/wan_family/assets/96972283/71765c04-e899-4ee9-90a9-67155c19aaa0)

 Wan-family（ワン・ファミリー）は、ペットと一緒に遊びに行けるスポットを、検索・保存・共有できるサイトです。<br>
 ユーザー自身でスポットの登録ができ、レビュー・写真の投稿もできます。<br>
 レスポンシブ対応をしているので、スマホからもご覧いただけます。

## こだわりのポイント
このアプリのテーマは、飼い主とペットが一緒に楽しい思い出を作れる場所を見つけることです。<br>
そこで、次の機能を実装しています。<br>
- スポットのレビュー評価に、ペットが楽しんでいたかどうかの評価も付けられる。（ワンちゃんの満足度）<br>
- スポットの情報として、ペットを同伴する際のルールを登録できる。

また、お出かけは計画しているときから楽しい気持ちでしたいもの。<br>
そこで、計画を立てるときに便利な機能を実装しています。<br>
- スポットのお気に入り機能（登録したスポットを一覧で見られる）<br>
- スポットに任意の名前のタグを付けられる機能（登録したタグごとにスポットを一覧で見られる）<br>
- 外部サイトの検索リンクを設置

## URL
http://wan-family-app.com

スポットの検索や、スポットの詳細情報・レビュー・写真の閲覧は、ログインせずに利用できます。<br>
スポットのお気に入り・タグの登録、レビュー・画像の評価はログインが必要になります。

### テスト用アカウント
メールアドレス： test01@email.com<br>
パスワード : test01

# 使用技術
## フロントエンド
- HTML
- CSS
  - Bulma-rails
- JavaScript
  - Google Maps API
- Bootstrap
## バックエンド
- Ruby 3.1.4
- Ruby on Rails 6.1.6
- MySQL 5.5
## インフラ
- Docker/Docker-compose
- CircleCi CI/CD
- Capistrano
- AWS
  - VPC
  - EC2
  - RDS
  - Route53 
  - S3
## テスト
- RSpec
## その他
- GitHub

# インフラ構成図
![インフラ構成図（Wan-Family）](https://github.com/moiwake/wan_family/assets/96972283/f0609ae8-a26e-41aa-b42a-eb1436b056cf)

## CircleCi CI/CD
- Githubへのpush時に、RspecとRubocopが自動で実行されます。
- masterブランチへのpushは、RspecとRubocopが成功した場合に、EC2への自動デプロイが実行されます。

# ER図
![ER図](https://github.com/moiwake/wan_family/assets/96972283/18450039-544f-42d7-a56c-a3ff80d75eff)

# 機能一覧
## 基本機能
### スポットを登録・更新する
- 施設名検索による住所の自動入力(Google Maps API)

https://github.com/moiwake/wan_family/assets/96972283/31ad8646-6569-4257-b646-241cabe7eb18

### スポットを検索する
- キーワード検索(ransack)
- エリア検索(ransack)
- マップ検索(Google Maps API)

https://github.com/moiwake/wan_family/assets/96972283/2ee41adc-30fb-4a60-b558-42d37db03b3d

### スポットをマーキングする
- スポットのお気に入り登録(Ajax)
  - ランキング機能
- スポットへのタグ付け(Ajax)

https://github.com/moiwake/wan_family/assets/96972283/c1bad1fb-a741-48a9-9166-d8b48a411cc0

### レビュー・画像を投稿する
- レビュー投稿
  - 役立ったの投稿(Ajax)
- 画像投稿(Active Storage)
  - 画像のいいね投稿(Ajax)
    - ランキング機能

https://github.com/moiwake/wan_family/assets/96972283/a9bc783b-624e-4f97-ab8c-3ab875d775ec

### マイページ
- お気に入りしたスポット一覧表示
- 付けたタグごとのスポット一覧表示
- 登録・更新したスポット一覧表示
- 投稿したレビュー一覧表示
- 投稿した画像一覧表示

https://github.com/moiwake/wan_family/assets/96972283/b8fd8fec-0e5a-4df5-8bdd-5beaa07d48e9

### その他
- スポット詳細ページの閲覧数によるランキング機能(impressionist)
- ページネーション機能(kaminari)
## 認証機能(devise)
- ユーザー登録
- ログイン
- パスワードの再設定
## 管理者機能(rails-admin)
- レコード管理

# テスト
## RSpec
### 単体テスト
- model
- forms
- queries
- services
- presenters
- decorators
- helpers
### 機能テスト
- request
### 統合テスト
- system

# 開発環境
- macOS: MonTerey
- Visual Studio Code
- Draw.io
- Fontawesome

# 今後の実装したい機能
- 現在地や指定地点の周辺にあるスポットを検索できる機能
- SNSでの共有機能
- スポットに付けたタグの共有機能
- スポットの詳細ページに、関連するおすすめスポットを表示
