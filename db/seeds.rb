# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


comedies = Category.create(name: "Comedies")
dramas = Category.create(name: "Dramas")


User.create(full_name: "marvinick", password_digest: "password", email: "marvin@seasalt.com")

Video.create(title: "Family Guy", description: "Funny Not", small_cover_url: "/tmp/family_guy.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Futurama", description: "Funny maybe", small_cover_url: "/tmp/monk.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Futurama", description: "Funny really", small_cover_url: "/tmp/futurama.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Monk", description: "Funny not again", small_cover_url: "/tmp/monk.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Family Guy", description: " not Funny", small_cover_url: "/tmp/south_park.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Family Guy", description: "maybe Funny", small_cover_url: "/tmp/family_guy.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Futurama", description: " not really Funny", small_cover_url: "/tmp/family_guy.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Family Guy", description: "fin Funny", small_cover_url: "/tmp/south_park.jpg", category: dramas,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Monk", description: "bol Funny", small_cover_url: "/tmp/family_guy.jpg", category: dramas,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "South Park", description: " nott Funny", small_cover_url: "/tmp/family_guy.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Family Guy", description: "Funny", small_cover_url: "/tmp/south_park.jpg", category: comedies,  large_cover_url: "/tmp/monk_large.jpg" )
Video.create(title: "Monk", description: " what Funny", small_cover_url: "/tmp/family_guy.jpg", category: dramas,  large_cover_url: "/tmp/monk_large.jpg" )


