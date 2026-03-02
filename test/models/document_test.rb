require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  # This helper ensures Active Storage is ready for testing
  include ActionDispatch::TestProcess

  setup do
    @user = users(:clerk)
    @document = documents(:tax_report)
  end

  test "valid document" do
    # We create a new one to test validation logic
    doc = Document.new(title: "New Audit", user: @user)
    doc.file.attach(io: StringIO.new("test content"), filename: "test.pdf", content_type: "application/pdf")
    assert doc.valid?
  end

  test "invalid without title" do
    @document.title = nil
    refute @document.valid?
  end

  test "enforces file attachment" do
    doc = Document.new(title: "No File", user: @user)
    # doc.file is NOT attached here
    refute doc.valid?
    assert_includes doc.errors[:file], "can't be blank"
  end
end
