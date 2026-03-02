require "test_helper"

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Required to use sign_in

  setup do
    @clerk = users(:clerk)
    @document = documents(:tax_report)
    # Mock a file upload for the 'create' test
    @file = fixture_file_upload("test/fixtures/files/test.pdf", "application/pdf")
  end

  test "should create document and initial workflow" do
    sign_in @clerk

    assert_difference -> { Document.count } => 1, -> { WorkflowInstance.count } => 1 do
      post documents_url, params: {
        document: { title: "New Revenue Audit", file: @file }
      }
    end

    assert_redirected_to document_path(Document.last)
    assert_equal "Document uploaded successfully.", flash[:notice]
  end

  test "generate_memo enqueues job and returns turbo stream" do
    sign_in @clerk

    # Verify the Job is enqueued
    assert_enqueued_with(job: GenerateMemoJob, args: [ @document.id ]) do
      post generate_memo_document_url(@document), as: :turbo_stream
    end

    # Verify the Turbo Stream response replaces the ai_section with the loading state
    assert_response :success

    assert_match(/turbo-stream action="replace" target="ai_section"/, response.body)

    assert_match(/Neural Analysis In Progress/, response.body)
    assert_match(/Scanning Taraba State Revenue Patterns/, response.body)
  end

  test "submit transitions workflow and redirects" do
    sign_in @clerk
    workflow = @document.workflow_instance

    # Ensure it's in draft before we start
    assert workflow.draft?

    patch submit_document_url(@document)

    assert_redirected_to workflow_instance_path(workflow)
    assert workflow.reload.pending?, "Workflow should be pending after submission"
  end

  test "unauthorized user is redirected" do
    # No sign_in
    get documents_url
    assert_redirected_to new_user_session_path
  end
end
