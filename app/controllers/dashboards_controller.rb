# app/controllers/dashboards_controller.rb
class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    prepare_kpis
    prepare_security_intelligence
    prepare_activity_feed
  end

  private

  def prepare_kpis
    @total_docs = Document.count
    @pending_workflows = WorkflowInstance.pending.count
    @pending_requisitions = Requisition.where(status: "pending").count
    @low_stock_items = InventoryItem.low_stock
  end

  def prepare_security_intelligence
    today_range = Time.zone.now.all_day

    # Total units issued today
    @today_issuance_count = Requisition.where(status: "approved", updated_at: today_range).sum(:quantity_requested)

    # Breakdown by Item
    @issuance_breakdown = Requisition.where(status: "approved", updated_at: today_range)
                                     .joins(:inventory_item)
                                     .group("inventory_items.name")
                                     .sum(:quantity_requested)
  end

  def prepare_activity_feed
    if current_user.admin? || current_user.approver?
      @recent_activities = Requisition.includes(:user, :inventory_item).order(updated_at: :desc).limit(6)
    else
      @recent_activities = current_user.requisitions.includes(:inventory_item).order(created_at: :desc).limit(6)
    end
    @latest_documents = Document.order(created_at: :desc).limit(4)
  end
end
