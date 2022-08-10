class CreateFavouritedLists < ActiveRecord::Migration[6.1]
  def change
    create_table :favourited_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
