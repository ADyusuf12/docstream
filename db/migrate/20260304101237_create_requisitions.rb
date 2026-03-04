class CreateRequisitions < ActiveRecord::Migration[8.0]
  def change
    create_table :requisitions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :inventory_item, null: false, foreign_key: true
      t.integer :quantity_requested
      t.string :status
      t.text :purpose
      t.string :serial_number_start
      t.string :serial_number_end

      t.timestamps
    end
  end
end
