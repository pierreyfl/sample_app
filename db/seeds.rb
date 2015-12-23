30.times do 
  user_types = [nil, 'Author', 'Admin']

  email = Faker::Internet.free_email

  User.create(email: email, password: 'password', password_confirmation: 'password', type: user_types[Random.rand(3)])
end

Admin.create(name: 'Admin User', email: 'admin@test.com', password: 'password', password_confirmation: 'password')
User.create(name: 'Normal User', email: 'user@test.com', password: 'password', password_confirmation: 'password')
Author.create(name: 'Author User', email: 'author@test.com', password: 'password', password_confirmation: 'password')
