# app/controllers/inventory_items_controller.rb
class InventoryItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_inventory_item, only: [:show, :new_restock, :process_restock]

  # GET /inventory_items
  def index
    @inventory_items = InventoryItem.all.order(category: :asc, name: :asc)
    # Using the scope we defined in the model for the header stats
    @low_stock_count = InventoryItem.low_stock.count
  end

  # GET /inventory_items/:id
  def show
    @requisitions = @inventory_item.requisitions.order(created_at: :desc)
  end

  # GET /inventory_items/:id/new_restock
  # Displays the "Deposit Slip" form for incoming stock
  def new_restock
    # @inventory_item is set by before_action
  end

  # PATCH /inventory_items/:id/process_restock
  # Logic to increase vault levels and log the specific reason/reference
  def process_restock
    amount = params[:restock_amount].to_i
    reference = params[:reference_note].presence || "No reference provided"

    if amount <= 0
      flash.now[:alert] = "Please enter a valid positive quantity for restock."
      render :new_restock, status: :unprocessable_entity
      return
    end

    # Explicitly tagging the Audit Trail with the "Why"
    @inventory_item.audit_comment = "OFFICIAL RESTOCK: Received #{amount} units. Reference: #{reference}"

    # Atomic update to the quantity
    new_quantity = @inventory_item.quantity + amount

    if @inventory_item.update(quantity: new_quantity)
      redirect_to inventory_items_path, notice: "Vault Updated: Successfully added #{amount} units to #{@inventory_item.name}."
    else
      flash.now[:alert] = "Critical Error: Could not update vault levels."
      render :new_restock, status: :unprocessable_entity
    end
  end

  private

  def set_inventory_item
    @inventory_item = InventoryItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to inventory_items_path, alert: "Asset not found in vault records."
  end
end
