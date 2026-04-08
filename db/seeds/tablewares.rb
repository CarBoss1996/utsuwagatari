store = Store.find_by!(tag_name: "test")
place = Place.find_by!(name: "1-A", store: store)

season_category = Category.find_by!(name: "季節", store: store)
shape_category  = Category.find_by!(name: "形状", store: store)

seasons = season_category.category_items.index_by(&:name)
shapes  = shape_category.category_items.index_by(&:name)

tablewares_data = [
  # 春
  { name: "桜散らし 平皿",     season: "春",  shape: "平皿" },
  { name: "春霞 深皿",         season: "春",  shape: "深皿" },
  { name: "花筏 椀",           season: "春",  shape: "椀"   },
  { name: "若草色 筒状",       season: "春",  shape: "筒状" },
  { name: "桃花 蓋物",         season: "春",  shape: "蓋物" },
  { name: "春草文 平皿",       season: "春",  shape: "平皿" },
  { name: "菜の花 深皿",       season: "春",  shape: "深皿" },
  { name: "春霖 椀",           season: "春",  shape: "椀"   },
  { name: "野の花 平皿",       season: "春",  shape: "平皿" },
  { name: "桜吹雪 蓋物",       season: "春",  shape: "蓋物" },
  { name: "うぐいす 筒状",     season: "春",  shape: "筒状" },
  { name: "春暁 深皿",         season: "春",  shape: "深皿" },
  { name: "藤浪 平皿",         season: "春",  shape: "平皿" },
  { name: "春風 椀",           season: "春",  shape: "椀"   },
  { name: "蕨文 深皿",         season: "春",  shape: "深皿" },
  { name: "朧月 平皿",         season: "春",  shape: "平皿" },
  { name: "春の野 蓋物",       season: "春",  shape: "蓋物" },
  { name: "桜色 筒状",         season: "春",  shape: "筒状" },

  # 夏
  { name: "青海波 平皿",       season: "夏",  shape: "平皿" },
  { name: "水玉 深皿",         season: "夏",  shape: "深皿" },
  { name: "涼風 筒状",         season: "夏",  shape: "筒状" },
  { name: "夏草 蓋物",         season: "夏",  shape: "蓋物" },
  { name: "流水 椀",           season: "夏",  shape: "椀"   },
  { name: "朝顔 平皿",         season: "夏",  shape: "平皿" },
  { name: "金魚 深皿",         season: "夏",  shape: "深皿" },
  { name: "水辺 蓋物",         season: "夏",  shape: "蓋物" },
  { name: "夏空 平皿",         season: "夏",  shape: "平皿" },
  { name: "竹林 筒状",         season: "夏",  shape: "筒状" },
  { name: "波文 椀",           season: "夏",  shape: "椀"   },
  { name: "蛍 深皿",           season: "夏",  shape: "深皿" },
  { name: "夏萩 平皿",         season: "夏",  shape: "平皿" },
  { name: "瀬戸の海 蓋物",     season: "夏",  shape: "蓋物" },
  { name: "涼月 椀",           season: "夏",  shape: "椀"   },
  { name: "向日葵 深皿",       season: "夏",  shape: "深皿" },
  { name: "夕凪 平皿",         season: "夏",  shape: "平皿" },
  { name: "青葉 筒状",         season: "夏",  shape: "筒状" },

  # 秋
  { name: "紅葉 平皿",         season: "秋",  shape: "平皿" },
  { name: "栗文様 深皿",       season: "秋",  shape: "深皿" },
  { name: "菊花 椀",           season: "秋",  shape: "椀"   },
  { name: "秋草 蓋物",         season: "秋",  shape: "蓋物" },
  { name: "月見 平皿",         season: "秋",  shape: "平皿" },
  { name: "錦秋 深皿",         season: "秋",  shape: "深皿" },
  { name: "山路 筒状",         season: "秋",  shape: "筒状" },
  { name: "秋霜 椀",           season: "秋",  shape: "椀"   },
  { name: "柿文 平皿",         season: "秋",  shape: "平皿" },
  { name: "萩文様 蓋物",       season: "秋",  shape: "蓋物" },
  { name: "実りの秋 深皿",     season: "秋",  shape: "深皿" },
  { name: "秋桜 平皿",         season: "秋",  shape: "平皿" },
  { name: "虫の音 筒状",       season: "秋",  shape: "筒状" },
  { name: "秋の水 椀",         season: "秋",  shape: "椀"   },
  { name: "銀杏 深皿",         season: "秋",  shape: "深皿" },
  { name: "晩秋 蓋物",         season: "秋",  shape: "蓋物" },
  { name: "夜長 平皿",         season: "秋",  shape: "平皿" },
  { name: "霧の朝 筒状",       season: "秋",  shape: "筒状" },

  # 冬
  { name: "雪花 平皿",         season: "冬",  shape: "平皿" },
  { name: "松竹梅 深皿",       season: "冬",  shape: "深皿" },
  { name: "冬牡丹 椀",         season: "冬",  shape: "椀"   },
  { name: "雪景色 蓋物",       season: "冬",  shape: "蓋物" },
  { name: "寒椿 平皿",         season: "冬",  shape: "平皿" },
  { name: "霜柱 深皿",         season: "冬",  shape: "深皿" },
  { name: "冬木立 筒状",       season: "冬",  shape: "筒状" },
  { name: "雪うさぎ 椀",       season: "冬",  shape: "椀"   },
  { name: "寒梅 平皿",         season: "冬",  shape: "平皿" },
  { name: "氷紋 蓋物",         season: "冬",  shape: "蓋物" },
  { name: "北風 深皿",         season: "冬",  shape: "深皿" },
  { name: "冬の月 筒状",       season: "冬",  shape: "筒状" },
  { name: "雪輪 平皿",         season: "冬",  shape: "平皿" },
  { name: "寒の水 椀",         season: "冬",  shape: "椀"   },
  { name: "凍て星 深皿",       season: "冬",  shape: "深皿" },
  { name: "冬晴れ 蓋物",       season: "冬",  shape: "蓋物" },
  { name: "雪解け 平皿",       season: "冬",  shape: "平皿" },
  { name: "樹氷 筒状",         season: "冬",  shape: "筒状" },

  # 通年
  { name: "白磁 平皿",         season: "通年", shape: "平皿" },
  { name: "青磁 椀",           season: "通年", shape: "椀"   },
  { name: "染付唐草 深皿",     season: "通年", shape: "深皿" },
  { name: "織部 筒状",         season: "通年", shape: "筒状" },
  { name: "志野 蓋物",         season: "通年", shape: "蓋物" },
  { name: "鉄絵草文 平皿",     season: "通年", shape: "平皿" },
  { name: "唐津 椀",           season: "通年", shape: "椀"   },
  { name: "萩焼 深皿",         season: "通年", shape: "深皿" },
  { name: "備前 筒状",         season: "通年", shape: "筒状" },
  { name: "信楽 蓋物",         season: "通年", shape: "蓋物" },
  { name: "益子 平皿",         season: "通年", shape: "平皿" },
  { name: "丹波 深皿",         season: "通年", shape: "深皿" },
  { name: "九谷 椀",           season: "通年", shape: "椀"   },
  { name: "有田 筒状",         season: "通年", shape: "筒状" },
  { name: "七宝文 平皿",       season: "通年", shape: "平皿" },
  { name: "麻の葉 深皿",       season: "通年", shape: "深皿" },
  { name: "市松 蓋物",         season: "通年", shape: "蓋物" },
  { name: "千鳥 椀",           season: "通年", shape: "椀"   },
  { name: "格子文 平皿",       season: "通年", shape: "平皿" },
  { name: "縞文 筒状",         season: "通年", shape: "筒状" },

  # 正月
  { name: "富士山 平皿",       season: "正月", shape: "平皿" },
  { name: "鶴亀 蓋物",         season: "正月", shape: "蓋物" },
  { name: "松文様 椀",         season: "正月", shape: "椀"   },
  { name: "寿 深皿",           season: "正月", shape: "深皿" },
  { name: "初春 筒状",         season: "正月", shape: "筒状" },
  { name: "宝船 平皿",         season: "正月", shape: "平皿" },
  { name: "打出の小槌 蓋物",   season: "正月", shape: "蓋物" },
  { name: "初日の出 椀",       season: "正月", shape: "椀"   },
]

tablewares_data.each do |data|
  tableware = Tableware.find_or_initialize_by(name: data[:name], store: store)
  tableware.save!

  tableware.tableware_places.find_or_create_by!(place: place)

  season_item = seasons[data[:season]]
  shape_item  = shapes[data[:shape]]

  [
    { category: season_category, item: season_item },
    { category: shape_category,  item: shape_item  },
  ].each do |entry|
    tableware.tableware_categories.find_or_create_by!(
      category:      entry[:category],
      category_item: entry[:item]
    )
  end
end

puts "#{tablewares_data.size}件のうつわを登録しました"
