class CreateSavedQrs < ActiveRecord::Migration[6.1]
  def change
    create_table :saved_qrs do |t|
      t.integer :quantity
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
