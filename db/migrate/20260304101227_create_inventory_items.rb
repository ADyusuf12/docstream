class CreateInventoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_items do |t|
      t.string :name
      t.string :category
      t.integer :quantity
      t.string :unit
      t.integer :low_stock_threshold

      t.timestamps
    end
  end
end
