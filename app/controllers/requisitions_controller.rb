# app/controllers/requisitions_controller.rb
class RequisitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_requisition, only: [:approve, :reject]

  def index
    # Admin/Approver sees the full queue; Clerks see their own history
    if current_user.admin? || current_user.approver?
      @requisitions = Requisition.includes(:user, :inventory_item).order(created_at: :desc)
    else
      @requisitions = current_user.requisitions.includes(:inventory_item).order(created_at: :desc)
    end
  end

  def new
    @requisition = current_user.requisitions.build
    @inventory_items = InventoryItem.where("quantity > 0")
  end

  def create
    @requisition = current_user.requisitions.build(requisition_params)
    @requisition.status = "pending"

    if @requisition.save
      redirect_to requisitions_path, notice: "Requisition for #{@requisition.inventory_item.name} submitted successfully."
    else
      @inventory_items = InventoryItem.all
      render :new, status: :unprocessable_entity
    end
  end

  def approve
    ActiveRecord::Base.transaction do
      item = @requisition.inventory_item

      if item.quantity < @requisition.quantity_requested
        redirect_to requisitions_path, alert: "Vault Error: Insufficient stock (Available: #{item.quantity})."
        return
      end

      # SUBTRACTION: Items are leaving the central vault
      new_stock_level = item.quantity - @requisition.quantity_requested

      if item.update!(quantity: new_stock_level) && @requisition.update!(status: "approved")
        redirect_to requisitions_path, notice: "Issuance Approved. #{item.name} deducted from vault."
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to requisitions_path, alert: "System Error: #{e.message}"
  end

  def reject
    if @requisition.update(status: "rejected")
      redirect_to requisitions_path, alert: "Requisition formally declined."
    else
      redirect_to requisitions_path, alert: "Update failed."
    end
  end

  private

  def set_requisition
    @requisition = Requisition.find(params[:id])
  end

  def requisition_params
    params.require(:requisition).permit(:inventory_item_id, :quantity_requested, :purpose)
  end
end
