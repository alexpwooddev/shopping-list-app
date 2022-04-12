class CreateListItems < ActiveRecord::Migration[6.1]
  def change
    create_table :list_items do |t|
      t.integer :quantity, default: 1
      t.integer :product_id
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
