
2.times do |i|
  User.create(email: "user-#{i+1}@example.com", password: "password", password_confirmation: "password")
end

Product.create({:name=>"tomato", :description => "single fresh tomato"})
Product.create({:name=>"milk", :description => "full fat milk"})
Product.create({:name=>"bread", :description => "sliced white break"})
Product.create({:name=>"bacon", :description => "streaky bacon"})
Product.create({:name=>"cheese", :description => "aged cheddar"})

User.all.each do |u|
  10.times do |i|
    u.lists.create(title: "ListPreview #{i+1} for #{u.email}", complete: i % 3 ? true : false )
    u.saved_qrs.create(product_id: i+1, quantity: 1)
  end
end

List.all.each do |l|
  5.times do |i|
    l.list_items.create(product_id: i+1, quantity: 1)
  end
end

