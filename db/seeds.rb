# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

role = Role.find_or_create_by!(name: 'Admin')

User.create!(
  name: 'RyanPham',
  email: 'ryanpham@gmail.com',
  password: 'ryanpham',
  password_confirmation: 'ryanpham',
  role_id: role.id)

10.times do |index|
  customer = Customer.create(
    name: "RyanPham #{index}",
    email: "ryanpham#{index}@gmail.com",
    password: "ryanpham#{index}",
    password_confirmation: "ryanpham#{index}")
  customer.create_passport(name: customer.name)
end

category = Category.create!(name: 'Ales')
category.beers.create(
  manufacurter: "Manufacturer 1",
  name: "Wheat Ales",
  country: "Germany",
  price: "15.0",
  description: "An authentic Bavarian style wheat beer, served unfiltered with its natural
    yeast and proteins. Using traditional special yeast, the beer is bursting with flavours
    that may surprise you.Reminiscent of bananas, cloves and lemons.
    It pairs very nicely with seafood, especially broiled or grilled fish such as salmon. Collingwood, ON"
)

category = Category.create(name: 'Lagers')
category.beers.create(
  manufacurter: "St. Louis, MO",
  name: "Light Lagers",
  country: "Barrie",
  price: "15.0",
  description: "Yeah, they know: “light” and “craft brewed” in the same sentence? Yes.
    Antigravity is a natural, craft-brewed light lager late-hopped for a complexity not
    usually found at the lighter end of the spectrum. Brewed with Canadian 2-row pale malt,
    Antigravity is a super-refreshing, clean-tasting, lager with a dry brush of European Saaz hops on the finish.Barrie, ON"
)

category = Category.create(name: 'Anomalies')
category.beers.create(
  manufacurter: "Manufacturer 1",
  name: "Wheat Ales",
  country: "Orleans",
  price: "15.0",
  description: "STRAY DOG THIS ONE CALIFORNIA COMMON
    Their take on a California Common has a moderate malt presence,
    intertwined with balanced notes of toast and caramel, finished with hints of
    rustic wood and mint on the nose. It has a beautiful copper colour that finishes
    as crisp as an autumn morning. So when your server or bartender asks what you’d like to drink,
    point at the menu and say, “I’ll have This One.” You’ll be glad you did.
    Orleans, ON"
)

category = Category.create(name: 'Rotating handles')
category.beers.create(
  manufacurter: "Manufacturer 1",
  name: "Wheat Ales",
  country: "Germany",
  price: "15.0",
  description: "The beer you’ve been waiting for. Keeps your taste satisfied while
    keeping your senses sharp. An all-day IPA naturally brewed with a complex array of malts,
    grains and hops. Balanced for optimal aromatics and a clean finish.
    The perfect reward for an honest day’s work and the ultimate companion to celebrate life’s simple pleasures"
)
