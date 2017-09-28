# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seed Users
user = {}
user['password'] = '123456'
gender = ["F", "M"]

ActiveRecord::Base.transaction do
  20.times do
    user['first_name'] = Faker::Name.first_name
    user['last_name'] = Faker::Name.last_name
    user['email'] = Faker::Internet.email
    user['gender'] = gender[rand(0..1)]
    user['phone'] = Faker::PhoneNumber.phone_number
    user['birthday'] = Faker::Date.between(50.years.ago, Date.today)

    User.create(user)
  end
end

# Seed Listings
listing = {}
uids = []
string = ""
one = ""
User.all.each { |u| uids << u.id }
am = ["Elevator", "Pets allowed", "Kitchen", "Air conditioning", "Internet", "Pool"]
city = ["KL", "Phuket", "Bangkok"]
ActiveRecord::Base.transaction do
  40.times do
    rand(0..am.count).times do
      one = ""
      if string.empty?
        string = am[rand(0..am.count - 1)]
      else
        one = am[rand(0..am.count - 1)]
        string += " #{one}" if !string.include? one
      end
    end
    listing['name'] = Faker::App.name
    listing['city'] = city.sample
    listing['amenities'] = string
    listing['price'] = rand(10..100)
    listing['description'] = Faker::Hipster.sentence
    listing["cancelation_rules"] = "no rules"
    listing["num_of_bedrooms"] = rand(1..4)
    listing["num_of_bathrooms"] = rand(1..listing["num_of_bedrooms"])
    listing['user_id'] = uids.sample

    Listing.create(listing)
    string = ""
  end
end
