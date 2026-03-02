require "test_helper"

class VersionTest < ActiveSupport::TestCase
  setup do
    @doc = documents(:tax_report)
  end

  test "stores and retrieves metadata as a hash" do
    metadata_payload = { "risk_level" => "low", "confidence" => 0.98 }

    version = Version.create!(
      document: @doc,
      content: "AI Analysis Complete",
      ai_generated: true,
      metadata: metadata_payload
    )

    # Reload from DB to ensure serialization worked
    version.reload
    assert_equal "low", version.metadata["risk_level"]
    assert_kind_of Hash, version.metadata
  end

  test "belongs to a document" do
    version = versions(:ai_memo)
    assert_respond_to version, :document
    assert_equal @doc.id, version.document_id
  end
end
