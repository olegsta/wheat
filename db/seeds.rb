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


points = [
           [55.831903,37.411961], [55.763338,37.565466], [55.763338,37.565466], [55.744522,37.616378], [55.780898,37.642889], [55.793559,37.435983], [55.800584,37.675638], [55.716733,37.589988], [55.775724,37.560840], [55.822144,37.433781], [55.874170,37.669838], [55.716770,37.482338], [55.780850,37.750210], [55.810906,37.654142], [55.865386,37.713329], [55.847121,37.525797], [55.778655,37.710743], [55.623415,37.717934], [55.863193,37.737000], [55.866770,37.760113], [55.698261,37.730838], [55.633800,37.564769], [55.639996,37.539400], [55.690230,37.405853], [55.775970,37.512900], [55.775777,37.442180], [55.811814,37.440448], [55.751841,37.404853], [55.627303,37.728976], [55.816515,37.597163], [55.664352,37.689397], [55.679195,37.600961], [55.673873,37.658425], [55.681006,37.605126], [55.876327,37.431744], [55.843363,37.778445], [55.875445,37.549348], [55.662903,37.702087], [55.746099,37.434113], [55.838660,37.712326], [55.774838,37.415725], [55.871539,37.630223], [55.657037,37.571271], [55.691046,37.711026], [55.803972,37.659610], [55.616448,37.452759], [55.781329,37.442781], [55.844708,37.748870], [55.723123,37.406067], [55.858585,37.484980]
       ]

lng, lat = 55.831903, 37.411961
100.times.each do |t|
  option = Random.rand(1..327)
  weight = Random.rand(10..1000)
  currency_id = Random.rand(1..8)
  
  weight_dimension_id = WeightDimension.all.sample.id
  params = {
      lat: lat + Random.rand(-1.0..1.0),
      lng: lng + Random.rand(-1.0..1.0),
      title: Faker::Commerce.product_name,
      option_id: option,
      weight: weight,
      weight_min: Random.rand(9..weight),
      weight_dimension_id: weight_dimension_id,
      weight_min_dimension_id: weight_dimension_id,
      price_weight_dimension_id: weight_dimension_id,
      price: Faker::Commerce.price,
      currency_id: currency_id,
      user_id: admin.id,
      address: Faker::Address.street_address,
      city: Faker::Address.city,
      trade_type_id: Random.rand(1..2),
      description: Faker::Lorem.paragraph
  }
  Position.create params
  p "#{t} позиция создана"
end