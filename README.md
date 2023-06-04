# Wan-Family
 Wan-family（ワン・ファミリー）は、ペットと一緒に遊びに行けるスポットを、検索・保存・共有できるサイトです。<br>
 ユーザー自身でスポットの登録ができ、レビュー・写真の投稿もできます。<br>
 レスポンシブ対応をしているので、スマホからもご覧いただけます。<br>

https://github.com/moiwake/wan_family/assets/96972283/a12f8067-89c5-4c4c-9f67-b89af65c3f27

## こだわりのポイント
このアプリのテーマは、飼い主とペットが一緒に楽しい思い出を作れる場所を見つけることです。<br>
そこで、次の機能を実装しています。<br>
- スポットのレビュー評価に、ペットが楽しんでいたかどうかの評価も付けられる。（ワンちゃんの満足度）<br>
- スポットの情報として、ペットを同伴する際のルールを登録できる。

また、お出かけは計画しているときから楽しい気持ちでしたいもの。<br>
そこで、計画を立てるときに便利な機能を実装しています。<br>
- スポットのお気に入り機能（登録したスポットを一覧で見られる）<br>
- スポットに任意の名前のタグを付けられる機能（登録したタグごとにスポットを一覧で見られる）
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
![インフラ構成図（Wan-family）](https://github.com/moiwake/wan_family/assets/96972283/82d317f7-6066-4645-90a8-f60adb7515ea)
## CircleCi CI/CD
- Githubへのpush時に、RspecとRubocopが自動で実行されます。
- masterブランチへのpushは、RspecとRubocopが成功した場合に、EC2への自動デプロイが実行されます。

# ER図
[ER図.pdf](https://github.com/moiwake/wan_family/files/11645124/ER.pdf)

# 機能一覧
## 基本機能
### スポットを登録・更新する
- 施設名検索による住所の自動入力(Google Maps API)
### スポットを検索する
- キーワード検索(ransack)
- エリア検索(ransack)
- マップ検索(Google Maps API)

https://github.com/moiwake/wan_family/assets/96972283/2d1cb2b7-b0bf-49d1-b338-d09e4a149c04

### スポットをマーキングする
- スポットのお気に入り登録(Ajax)
  - ランキング機能
- スポットへのタグ付け(Ajax)

https://github.com/moiwake/wan_family/assets/96972283/83e88b30-26af-490d-86e5-f73a63cbf552

### レビュー・画像を投稿する
- レビュー投稿
  - 役立ったの投稿(Ajax)
- 画像投稿(Active Storage)
  - 画像のいいね投稿(Ajax)
    - ランキング機能

https://github.com/moiwake/wan_family/assets/96972283/d8c62d8f-5f10-4841-8988-d0973d349fe2

### マイページ
- お気に入りしたスポット一覧表示
- 付けたタグごとのスポット一覧表示
- 登録・更新したスポット一覧表示
- 投稿したレビュー一覧表示
- 投稿した画像一覧表示
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
