# CLAUDE.md — うつわがたり

日本料理店向けのうつわの管理アプリ。店舗ごとにサブドメインでアクセスし、器の管理・検索・保管場所管理を提供する。

---

## 技術スタック

| 項目 | 内容 |
|---|---|
| Ruby | `.ruby-version` 参照 |
| Rails | 7.2.2 |
| DB | MySQL（mysql2 gem） |
| テンプレート | HAML（haml-rails） |
| CSS | SASS（sassc-rails）+ Bootstrap 5.3 |
| JS | Stimulus（stimulus-rails）+ Turbo（turbo-rails）+ Importmap |
| 認証 | bcrypt（has_secure_password、自前セッション管理） |
| フォーム | simple_form |
| ページネーション | pagy ~> 9.0（Pagy::Backend / Pagy::Frontend） |
| 検索 | ransack（未使用部分あり）+ 自作 TablewaresFilter |
| 複合フィルター | where_exists gem（AND条件での category_item 絞り込み） |
| 画像 | ActiveStorage（has_one_attached / has_many_attached） |
| Select UI | Select2 v4.1（CDN経由、jQuery依存のためImportmap不使用） |

---

## ディレクトリ構造

```
app/
  controllers/
    application_controller.rb     # set_store（サブドメイン解決）
    admin/                        # 管理者画面
    owner/                        # 店舗オーナー画面
    front/                        # 一般ユーザー（従業員）画面
  models/
  views/
    layouts/
      admin/main.html.haml
      owner/main.html.haml
      front/main.html.haml        # front レイアウト
      front/_header.html.haml     # SVGアイコン、検索モーダル、通知バッジ
      front/_footer.html.haml
      front/_icon_*.html.haml     # SVGアイコンパーシャル
  filters/
    tablewares_filter.rb          # 器の検索フィルター（名前・カテゴリ・場所）
  helpers/
    data_card_helper.rb           # 汎用カード表示ヘルパー（card_item / card_value）
    application_helper.rb         # Pagy::Frontend include
  javascript/controllers/
    search_overlay_controller.js  # 検索モーダル開閉
    select2_controller.js         # Select2初期化
    inquiry_controller.js         # お問い合わせ既読処理（details toggle）
    image_gallery_controller.js   # 器詳細の画像ギャラリー
    auto_submit_controller.js     # フォーム自動送信
    toast_controller.js           # トースト通知
  assets/stylesheets/
    front/                        # front用SASS
      _variables.sass             # $primary: #FDBE91, $gray: #E4E4E4
      _base.sass
      main.css.sass
      styles/_header.sass
      styles/_home.sass           # ログイン・器一覧・お問い合わせ等
      styles/_tablewares.sass
      styles/_footer.sass
      components/_btn.sass
      components/_link.sass
    owner/                        # owner用SASS
    admin/                        # admin用SASS
config/
  routes.rb                       # draw(:admin), draw(:owner), draw(:front)
  routes/
    admin.rb
    owner.rb
    front.rb
  application.rb                  # tld_length: 0（localhost サブドメイン用）
```

---

## ルーティング

### サブドメイン設計
- `config.action_dispatch.tld_length = 0`（localhost 開発用）
- 全アクセスはサブドメインで店舗を解決（`ApplicationController#set_store`）
- サブドメインなし or 無効な場合は 404

### front（一般ユーザー・従業員）
```
GET  /                  home#index
GET  /terms             home#terms
GET  /inquiries         inquiries#index
GET  /inquiries/new     inquiries#new
POST /inquiries         inquiries#create
POST /inquiries/confirm inquiries#confirm   # 確認画面
PATCH /inquiries/:id/read inquiries#read   # 既読処理
resources :sessions     (new, create, destroy)
resources :tablewares   (full) + GET /tablewares/search
resources :places       (index, show)
```

### owner（店舗オーナー）
```
namespace :owner
  resources :tablewares   (full) + image_upload, image_destroy
  resources :categories > resources :items
  resources :inquiries    (index, show)
  resources :places       (full) + patch :update_floor_map
  resources :sessions     (new, create)
```

### admin（管理者）
```
namespace :admin
  resources :stores > resources :users (+ GET confirm)
  resources :inquiries (index, show, update) > resources :answers (create, destroy)
  resources :sessions  (new, create)
```

---

## モデル

### Store
- `tag_name`: サブドメイン識別子
- `active`: boolean（false の店舗は 404）
- `has_one_attached :floor_map`
- `has_many :users, :tablewares, :categories, :places, :inquiries`

### User
- `role`: enum `[ :user, :store_owner, :admin ]`（integer, default: 0）
- `has_secure_password`
- `belongs_to :store`

### Tableware（器）
- `has_many_attached :images`
- `has_many :tableware_categories, :histories` （dependent: :destroy）
- `has_many :places, through: :tableware_places`
- カテゴリ情報は `categories_info`、保管場所は `places_info` メソッドで表示

### TablewareCategory（中間テーブル）
- `tableware / category / category_item` の3者を結ぶ
- `scope :currents` — `category_item_id` が nil でないもの

### Place（保管場所）
- `has_one_attached :image`
- `scope :active` — `active: true` のもの

### Inquiry（お問い合わせ）
- `status`: enum `{ pending: 0, in_progress: 1, not_required: 2 }`
- `has_many :answers`
- `memo`: 管理者用メモ（ユーザーには非表示）

### Answer（返答）
- `read_at`: datetime（nil = 未読、既読時に Time.current をセット）

---

## 認証・認可

| 画面 | セッションキー | 対象ロール |
|---|---|---|
| front | `session[:front_user_id]` | user / store_owner / admin |
| owner | `session[:user_id]` | store_owner / admin |
| admin | `session[:user_id]` | admin のみ |

- 各 namespace に `MainController` があり、`check_auth` / `set_store` を before_action で管理
- front の `check_auth` は `skip_before_action` で公開アクションを除外

---

## 主要機能

### 器検索（front / owner）
- `TablewaresFilter` クラスで処理（`app/filters/`）
- 名前: LIKE検索
- カテゴリ: `where_exists` で AND条件（同じカテゴリ内の複数選択も可）
- 保管場所: `where_exists` で OR条件
- Select2（CDN）でマルチセレクト UI

### 閲覧履歴
- `session[:recently_viewed]` に tableware_id を最大20件保存
- Turbo prefetch によるホバーでの誤記録を防ぐため、`X-Sec-Purpose: prefetch` ヘッダーをチェック

### お問い合わせフロー（front）
1. `GET /inquiries/new` → 入力フォーム
2. `POST /inquiries/confirm` → 確認画面（バリデーションのみ、保存なし）
3. `POST /inquiries` → 送信・保存 → `/inquiries` へリダイレクト

### 未読通知
- `Answer#read_at` で既読管理
- ヘッダーのユーザーアイコンに未読バッジ（赤丸＋pulseアニメーション）
- お問い合わせ詳細を開く（`<details>` toggle）と Stimulus 経由で `PATCH /inquiries/:id/read`

### 画像ギャラリー（器詳細）
- `image_gallery_controller.js` でサムネイル切り替え

### 保管場所フロアマップ
- `PATCH /owner/places/update_floor_map` で Turbo Stream レスポンス（モーダル内更新）

---

## 開発ルール

### マイグレーション
- カラム追加時は `after: :column_name` で `created_at` の手前に配置する

### HAML
- インデントは **2スペース**（タブ不可）
- SVGアイコンは `app/views/layouts/front/_icon_*.html.haml` にパーシャルとして切り出す

### SASS
- カラー変数: `$primary: #FDBE91`（オレンジ）、`$gray: #E4E4E4`
- namespace ごとにディレクトリを分離（front / owner / admin）
- Bootstrap の `media-breakpoint-down` mixin を使用

### JavaScript
- Stimulus を使用。コントローラー名はファイル名に対応（`search_overlay_controller.js` → `data-controller="search-overlay"`）
- Select2 は jQuery 依存のため CDN タグで読み込む（Importmap 経由は不可）
- `data: { turbo: false }` をファイルアップロードを含むフォームに付与

### テスト
- テストファイルは現在存在しない（`config.generators.system_tests = nil`）
- `brakeman`（セキュリティ）/ `rubocop-rails-omakase`（スタイル）は導入済み

### Generator設定
- `helper: false`、`jbuilder: false`（自動生成しない）

---

## ローカル開発

```bash
# サブドメインアクセスに /etc/hosts の設定が必要
# 例: 127.0.0.1 test.localhost
# store.tag_name が "test" の場合 → http://test.localhost:3000 でアクセス
```
