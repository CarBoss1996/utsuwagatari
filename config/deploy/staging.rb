# staging は production と同じサーバーでもOK（別ディレクトリで共存）
# 別サーバーにする場合は異なるIPを指定する
server "YOUR_SERVER_IP", user: "deploy", roles: %w[app db web]

set :ssh_options, {
  keys: %w[~/.ssh/id_ed25519],
  forward_agent: true,
  auth_methods: %w[publickey]
}
