class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
