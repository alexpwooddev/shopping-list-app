class RemoveProductIdFromListItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :list_items, :product_id, :integer
  end
end
