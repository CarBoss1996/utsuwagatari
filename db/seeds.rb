store_source = [
  %w(test テスト店舗 true),
]

store_source.each do |values|
  store = Store.find_or_initialize_by(tag_name: values.shift)
  store.name = values.shift
  store.active = true
end

load Rails.root.join("db/seeds/places.rb")
load Rails.root.join("db/seeds/tablewares.rb")
