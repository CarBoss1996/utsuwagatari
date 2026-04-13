# config valid for current version and patch releases of Capistrano
lock "~> 3.20.0"

set :application, "utuwagatari"
set :repo_url, "git@github.com:CarBoss1996/utsuwagatari.git"

set :branch, :main

set :deploy_to, "/var/www/utuwagatari"

set :rbenv_type, :user
set :rbenv_ruby, File.read(".ruby-version").strip

# リリースを5世代保持
set :keep_releases, 5

# デプロイ先に共有するファイル・ディレクトリ
append :linked_files, "config/master.key", ".env"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "storage", "public/system"

# Puma 設定
set :puma_threads, [0, 5]
set :puma_workers, 0
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :deploy do
  desc "アセットのシンボリックリンクを更新"
  after :finishing, "deploy:cleanup"
end
