
2.times do |i|
  User.create(email: "user-#{i+1}@example.com", password: "password", password_confirmation: "password")
end

User.all.each do |u|
  10.times do |i|
    u.lists.create(title: "List #{i+1} for #{u.email}", complete: i % 3 ? true : false )
  end
end
