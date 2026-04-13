# Hetzner VPS セットアップ手順

## 1. Hetzner でサーバーを作る

1. https://www.hetzner.com/cloud にアクセスしてアカウント作成
2. 「Add Server」→ 以下を選択
   - **Location**: Nuremberg（EU）or Ashburn（US）
   - **Image**: Ubuntu 22.04
   - **Type**: CX22（2コア/4GB RAM、€3.99/月）
   - **SSH keys**: 自分のSSH公開鍵を登録（`cat ~/.ssh/id_ed25519.pub`）
3. サーバー作成 → IPアドレスをメモ

## 2. 初期サーバー設定（rootでSSH接続）

```bash
ssh root@YOUR_SERVER_IP

# システム更新
apt update && apt upgrade -y

# deployユーザー作成
adduser deploy
usermod -aG sudo deploy

# SSH鍵をdeployユーザーにコピー
mkdir -p /home/deploy/.ssh
cp ~/.ssh/authorized_keys /home/deploy/.ssh/
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys

# 必要なパッケージをインストール
apt install -y git curl build-essential libssl-dev libreadline-dev zlib1g-dev \
  libmysqlclient-dev nginx certbot python3-certbot-nginx

# rootでのSSHログインを無効化（セキュリティ）
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd
```

## 3. deployユーザーでサーバーに入り直してRuby/MySQLをセットアップ

```bash
ssh deploy@YOUR_SERVER_IP

# rbenv インストール
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Ruby インストール（時間がかかる）
rbenv install 3.4.2
rbenv global 3.4.2
gem install bundler --no-document

# MySQL インストール
sudo apt install -y mysql-server
sudo systemctl enable mysql

# MySQLの初期設定
sudo mysql_secure_installation

# データベースとユーザー作成
sudo mysql -u root -p
```

MySQLで以下を実行：
```sql
CREATE DATABASE utuwagatari_production DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'utuwagatari'@'localhost' IDENTIFIED BY 'YOUR_STRONG_PASSWORD';
GRANT ALL PRIVILEGES ON utuwagatari_production.* TO 'utuwagatari'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 4. デプロイ先ディレクトリの準備

```bash
sudo mkdir -p /var/www/utuwagatari
sudo chown deploy:deploy /var/www/utuwagatari

# shared ディレクトリと .env を配置
mkdir -p /var/www/utuwagatari/shared/config
mkdir -p /var/www/utuwagatari/shared/tmp/{pids,sockets}
mkdir -p /var/www/utuwagatari/shared/log
mkdir -p /var/www/utuwagatari/shared/storage

# master.key をサーバーに配置
# ローカルから: scp config/master.key deploy@YOUR_SERVER_IP:/var/www/utuwagatari/shared/config/master.key
```

## 5. 環境変数の設定（.env）

```bash
vi /var/www/utuwagatari/shared/.env
```

`.env.example` の内容を参考に実際の値を設定する。

## 6. Nginx の設定

```bash
sudo cp /var/www/utuwagatari/current/config/nginx/utuwagatari.conf /etc/nginx/sites-available/utuwagatari
# yourdomain.com を実際のドメインに書き換える
sudo vi /etc/nginx/sites-available/utuwagatari

sudo ln -s /etc/nginx/sites-available/utuwagatari /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# SSL証明書（ワイルドカード証明書 → DNS認証が必要）
sudo certbot certonly --manual --preferred-challenges dns -d "*.yourdomain.com" -d "yourdomain.com"

sudo nginx -t && sudo systemctl reload nginx
```

## 7. Capistrano でデプロイ

ローカルのターミナルで：

```bash
# config/deploy/production.rb の YOUR_SERVER_IP を実際のIPに書き換える
# master.key をサーバーにコピー
scp config/master.key deploy@YOUR_SERVER_IP:/var/www/utuwagatari/shared/config/master.key

# 初回デプロイ
cap production deploy
```

## 8. ドメインのDNS設定

ドメインのDNSレコードに以下を追加：
```
A     yourdomain.com         YOUR_SERVER_IP
A     *.yourdomain.com       YOUR_SERVER_IP
```

## デプロイコマンド（2回目以降）

```bash
cap production deploy
```
