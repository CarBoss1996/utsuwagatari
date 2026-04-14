# HetznerのサーバーIPを設定する（VPS作成後に変更）
server "133.117.72.20", user: "deploy", roles: %w[app db web]

set :ssh_options, {
  keys: %w[~/.ssh/id_ed25519],
  forward_agent: true,
  auth_methods: %w[publickey]
}
