# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tags = %w[いぬ ねこ 小動物 鳥 爬虫類 その他 相談 質問]
tags.each do |tag|
  Tag.find_or_create_by(name: tag)
end