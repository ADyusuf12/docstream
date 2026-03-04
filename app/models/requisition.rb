# app/models/requisition.rb
class Requisition < ApplicationRecord
  audited
  belongs_to :user
  # Use the specific name from your generation
  belongs_to :inventory_item

  validates :quantity_requested, presence: true, numericality: { greater_than: 0 }

  scope :open, -> { where(status: [ "pending", "approved" ]) }
end
