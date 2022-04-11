class CreateListItems < ActiveRecord::Migration[6.1]
  def change
    create_table :list_items do |t|
      t.integer :quantity, default: 1
      t.integer :product_id
      t.integer :list_id

      t.timestamps
    end
  end
end
