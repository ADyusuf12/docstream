class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [ :show, :edit, :update, :generate_memo, :submit ]

  def index
    @documents = Document.includes(:workflow_instance, :user).order(created_at: :desc)
  end

  def show; end

  def new
    @document = Document.new
  end

  def create
    @document = current_user.documents.build(document_params)

    Document.transaction do
      if @document.save
        # Creates the initial 'draft' instance as planned in the TIRS workflow
        @document.create_workflow_instance!(user: current_user)
        redirect_to @document, notice: "Document uploaded successfully."
      else
        render :new, status: :unprocessable_content
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_content
  end

  def edit; end

  def update
    if @document.update(document_params)
      redirect_to @document, notice: "Document updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def submit
    # Find the existing workflow instance created during 'create'
    @workflow = @document.workflow_instance

    if @workflow && @workflow.submit!
      # We use respond_to to ensure Turbo handles the redirect as a full-page visit
      respond_to do |format|
        format.html { redirect_to workflow_instance_path(@workflow), notice: "Workflow started successfully." }
        format.turbo_stream { redirect_to workflow_instance_path(@workflow), notice: "Workflow started successfully." }
      end
    else
      redirect_to @document, alert: "Workflow could not be initiated. Check if it's already submitted."
    end
  end

  def generate_memo
    GenerateMemoJob.perform_later(@document.id)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "ai_section",
          partial: "documents/ai_loading"
        )
      end
      format.html { redirect_to @document }
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :file)
  end
end
