user1 = User.create(first_name: "Admin", last_name: "User", role: 0, email: "admin@email.com", password: "123456")
user1.add_role(:admin)
user2 = User.create(first_name: "User", last_name: "One", email: "user1@email.com", password: "123456")
user2.add_role(:user)

["Fiction", "Non-Fiction", "Children’s Literature", "Poetry", "Graphic Novels/Comics", "Classics", "Religious/Spiritual", "Anthology/Short Stories"].each do |name|
  Category.create(name: name)
end
