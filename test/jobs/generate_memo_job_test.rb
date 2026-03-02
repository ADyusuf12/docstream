require "test_helper"

class GenerateMemoJobTest < ActiveJob::TestCase
  setup do
    @document = documents(:tax_report)
    # We "stub" sleep so the test runs in milliseconds, not 4 seconds
    GenerateMemoJob.any_instance.stubs(:sleep).returns(true)
  end

  test "creates a version with AI metadata and audits" do
    assert_difference -> { Version.count } => 1, -> { Audited::Audit.count } => 1 do
      GenerateMemoJob.perform_now(@document.id)
    end

    version = Version.last
    assert version.ai_generated
    assert_includes [ "High", "Low" ], version.metadata["risk_score"]
    assert_not_nil version.metadata["confidence"]
  end

  test "broadcasts targeted stream actions" do
    broadcasts = capture_broadcasts("document_status_#{@document.id}") do
      GenerateMemoJob.perform_now(@document.id)
    end

    assert broadcasts.any? { |b| b.include?('action="prepend"') && b.include?('target="audit_log_container"') }
    assert broadcasts.any? { |b| b.include?('action="replace"') && b.include?('target="ai_section"') }
    assert broadcasts.any? { |b| b.include?('action="remove"') && b.include?('target="empty_audit_msg"') }
  end

  test "properly attributes the AI engine in the audit trail" do
    GenerateMemoJob.perform_now(@document.id)
    # Find the audit associated with the newly created version
    audit = Version.last.audits.last
    assert_equal "AI Intelligence Engine", audit.username
  end
end
