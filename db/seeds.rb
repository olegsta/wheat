# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.where(email: "admin@admin.com").first_or_create(password: "123123123", fullname: "Кононенко Павел Вячеславович", phones: ["+7 (988) 999 6543"])

puts "Создание категории"
Category::CATEGORY.each do |title|
  FactoryGirl.create(:category, :title => title)
end


puts "Создание размерности"
WeightDimension::DIMENSIONS.each do |weight_dimension|
  WeightDimension.where(name: weight_dimension[:name]).first_or_create(:convert => weight_dimension[:convert])
end


puts "Создание валют"
Currency::CURRENCY.each do |currency|
  Currency.where(name: currency[:name]).first_or_create
end

10.times do
  u = User.create({
    email: Faker::Internet.free_email,
    fullname: Faker::Name.name,
    password: "123123123",
    phones: ["+7 (988) 999 6543"]
  })

  10.times do
    lat = 55.831903 + Random.rand(-1.0..1.0)
    lng = 37.411961 + Random.rand(-1.0..1.0)
    option = Random.rand(1..327)
    weight = Random.rand(10..1000)
    currency_id = Random.rand(1..8)
    
    weight_dimension_id = WeightDimension.all.sample.id
    params = {
        lat: lat,
        lng: lng,
        title: Faker::Commerce.product_name,
        option_id: option,
        weight: weight,
        weight_min: Random.rand(9..weight),
        weight_dimension_id: weight_dimension_id,
        weight_min_dimension_id: weight_dimension_id,
        price_weight_dimension_id: weight_dimension_id,
        price: Faker::Commerce.price,
        price_discount: Random.rand(5.0..50.0),
        currency_id: currency_id,
        user_id: u.id,
        address: Faker::Address.street_address,
        city: Faker::Address.city,
        trade_type_id: Random.rand(1..2),
        description: Faker::Lorem.paragraph
    }
    pos = Position.create params
  end
end
