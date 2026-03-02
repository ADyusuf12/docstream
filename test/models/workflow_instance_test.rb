require "test_helper"

class WorkflowInstanceTest < ActiveSupport::TestCase
  setup do
    @doc = documents(:tax_report)
    @clerk = users(:clerk)
    # Create a fresh instance for testing transitions
    @workflow = WorkflowInstance.create!(document: @doc, user: @clerk)
  end

  test "starts in draft state" do
    assert @workflow.draft?
  end

  test "validates transition from draft to pending" do
    assert @workflow.may_submit?, "Should be allowed to submit from draft"
    @workflow.submit!
    assert @workflow.pending?
  end

  test "blocks illegal transition: draft to approved" do
    refute @workflow.may_approve?, "Should NOT be allowed to approve from draft"
    assert_raises AASM::InvalidTransition do
      @workflow.approve!
    end
  end

  test "allows approval only from pending" do
    @workflow.submit! # Move to pending
    assert @workflow.may_approve?
    @workflow.approve!
    assert @workflow.approved?
  end
end
