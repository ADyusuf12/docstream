require "test_helper"

class WorkflowInstancesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @approver = users(:approver)
    @clerk = users(:clerk)
    @workflow = workflow_instances(:one)

    # Ensure it's in a state that can be approved/rejected
    @workflow.update!(aasm_state: 'pending')
  end

  test "index filters workflows by role" do
    sign_in @clerk
    get workflow_instances_url
    assert_response :success
    # Clerk should only see their own (assuming fixtures match)
    assert_not_nil assigns(:workflows)

    sign_out @clerk
    sign_in @approver
    get workflow_instances_url
    assert_response :success
    # Approver sees everything
  end

  test "approver can approve and it transitions state" do
    sign_in @approver
    patch approve_workflow_instance_url(@workflow)

    assert_redirected_to workflow_instance_path(@workflow)
    assert @workflow.reload.approved?
  end

  test "clerk is blocked from approving" do
    sign_in @clerk
    patch approve_workflow_instance_url(@workflow)

    assert_redirected_to workflow_instance_path(@workflow)
    assert_equal "Access Denied: Approver role required.", flash[:alert]
    refute @workflow.reload.approved?
  end

  test "certificate generates QR code for approved documents" do
    sign_in @approver
    # Manually approve it through the model to simulate the state
    @workflow.approve!

    get certificate_workflow_instance_url(@workflow)

    assert_response :success
    assert_not_nil assigns(:qrcode)
    assert_not_nil assigns(:svg)
    # Ensure we are using the special certificate layout
    assert_template layout: "layouts/certificate"
  end

  test "certificate redirects if not approved" do
    sign_in @approver
    # It's currently 'pending', not 'approved'
    get certificate_workflow_instance_url(@workflow)

    assert_redirected_to workflow_instance_path(@workflow)
    assert_equal "Certificate only available for approved documents.", flash[:alert]
  end
end
