puts "Cleaning Users..."
User.destroy_all

User.create!([
  { email: "admin@docstream.com", password: "password", role: :admin },
  { email: "clerk@docstream.com", password: "password", role: :clerk },
  { email: "approver@docstream.com", password: "password", role: :approver }
])
