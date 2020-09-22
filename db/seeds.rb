# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts 'start seed'
FFaker::Random.seed = 12345

1.upto(10000) do |i|
  Article.create(
    title: "Title#{i}",
    content: [
      FFaker::AddressJA.address,
      FFaker::JobJA.title,
      FFaker::LoremJA.paragraphs
    ].join("\n")
  )
end
puts 'es create_index'
Article.create_index!
puts 'es import'
Article.__elasticsearch__.import

puts 'seed end'
