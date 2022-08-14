
2.times do |i|
  User.create(email: "user-#{i+1}@example.com", password: "password", password_confirmation: "password")
end

Product.create({:name=>"tomato", :description => "single fresh tomato"})
Product.create({:name=>"milk", :description => "full fat milk"})
Product.create({:name=>"bread", :description => "sliced white break"})
Product.create({:name=>"bacon", :description => "streaky bacon"})
Product.create({:name=>"cheese", :description => "aged cheddar"})

User.all.each do |user|
  10.times do |i|
    user.lists.create(title: "List #{i+1} for #{user.email}", complete: i % 2 == 0 ? true : false, published: i % 2 == 0 ? true : false )
    user.saved_qrs.create(product_id: i+1, quantity: 1)
  end
end

User.first.favourited_lists.create(list_id: User.last.lists.last.id)
User.last.favourited_lists.create(list_id: User.first.lists.last.id)

List.all.each do |list|
  list.list_items.create(product_id: 1, quantity: 1)
  list.list_items.create(product_id: 2, quantity: 6)
  list.list_items.create(product_id: 3, quantity: 2)
  list.list_items.create(product_id: 4, quantity: 8)
  list.list_items.create(product_id: 5, quantity: 1)
end

