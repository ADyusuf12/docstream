class WorkflowInstancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workflow, only: [ :show, :approve, :reject, :certificate ]
  before_action :authorize_approver!, only: [ :approve, :reject ]

  def index
    if current_user.approver? || current_user.admin?
      @workflows = WorkflowInstance.all.order(created_at: :desc)
    else
      @workflows = WorkflowInstance.where(user: current_user).order(created_at: :desc)
    end
  end

  def show
    # Combined audits for the timeline/sidebar
    workflow_audits = @workflow.respond_to?(:audits) ? @workflow.audits : []
    document_audits = @workflow.document.respond_to?(:audits) ? @workflow.document.audits : []
    @audits = (workflow_audits + document_audits).sort_by(&:created_at).reverse
  end

  def approve
    if @workflow.approve!
      respond_to do |format|
        format.html { redirect_to @workflow, notice: "Document approved." }
        format.turbo_stream { redirect_to @workflow }
      end
    else
      redirect_to @workflow, alert: "Approval failed."
    end
  end

  def reject
    if @workflow.reject!
      respond_to do |format|
        format.html { redirect_to @workflow, alert: "Document rejected." }
        format.turbo_stream { redirect_to @workflow }
      end
    else
      redirect_to @workflow, alert: "Rejection failed."
    end
  end

  def certificate
    unless @workflow.approved?
      redirect_to @workflow, alert: "Certificate only available for approved documents."
      return
    end

    approval_audit = @workflow.audits.where(action: "update").find do |a|
      a.audited_changes["aasm_state"]&.last == "approved"
    end

    # We assign the audit user to @approver so the view knows who signed it
    @approver = approval_audit&.user || current_user

    verification_url = workflow_instance_url(@workflow)

    @qrcode = RQRCode::QRCode.new(verification_url)
    @svg = @qrcode.as_svg(
      color: "0f172a",
      shape_rendering: "crispEdges",
      module_size: 3,
      standalone: true,
      use_path: true
    )

    render layout: "certificate"
  end

  private

  def set_workflow
    @workflow = WorkflowInstance.find(params[:id])
  end

  def authorize_approver!
    unless current_user.approver? || current_user.admin?
      redirect_to @workflow, alert: "Access Denied: Approver role required."
    end
  end
end
