# app/models/inventory_item.rb
class InventoryItem < ApplicationRecord
  audited
  has_many :requisitions

  validates :name, presence: true, uniqueness: true

  # Helper scope for the dashboard counters
  scope :low_stock, -> { where("quantity <= low_stock_threshold") }
end
