store = Store.find_by!(tag_name: "test")

places_data = [
  "1-A", "1-B", "1-C",
  "2-A", "2-B", "2-C",
  "3-A", "3-B", "3-C",
  "倉庫"
]

places_data.each do |name|
  Place.find_or_create_by!(name: name, store: store) do |p|
    p.active = true
  end
end

puts "#{places_data.size}件の保管場所を登録しました"
