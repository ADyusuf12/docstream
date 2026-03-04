puts "Cleaning Documents & Workflows..."
# We must destroy Workflows first because they belong to Documents
WorkflowInstance.destroy_all
Document.destroy_all

clerk = User.find_by(role: :clerk)

# Helper method to handle the specific "Validation: File Presence" requirement
def create_demo_document(user, title, filename, content)
  doc = user.documents.new(title: title)
  path = Rails.root.join("demo_docs", filename)

  if File.exist?(path)
    # Attach the file BEFORE saving so the 'presence: true' validation passes
    doc.file.attach(io: File.open(path), filename: filename)
    doc.save!

    # Create the versioning
    doc.versions.create!(content: content, ai_generated: false)
    doc
  else
    puts "❌ Error: demo_docs/#{filename} not found. Document '#{title}' skipped."
    nil
  end
end

# 1. Create Documents
doc1 = create_demo_document(clerk, "Tax Memo Draft", "tax_memo.pdf", "Initial draft of tax memo.")
doc2 = create_demo_document(clerk, "Client Letter", "client_letter.pdf", "Initial draft of client letter.")
doc3 = create_demo_document(clerk, "Internal Policy Note", "policy_note.pdf", "Draft of remote work guidelines.")
doc4 = create_demo_document(clerk, "Rejected Draft", "rejected_draft.pdf", "Incomplete draft report.")

# 2. Create AI Summaries (Only if doc creation succeeded)
if doc1
  doc1.versions.create!(
    content: "AI-generated summary: Highlights proposed changes to filing deadlines.",
    ai_generated: true
  )
end

# 3. Initialize Workflows
# Workflow 1: Pending
if doc1
  wf1 = WorkflowInstance.create!(document: doc1, user: clerk)
  wf1.submit!
end

# Workflow 2: Approved
if doc2
  wf2 = WorkflowInstance.create!(document: doc2, user: clerk)
  wf2.submit!
  wf2.approve!
end

# Workflow 3: Rejected
if doc3
  wf3 = WorkflowInstance.create!(document: doc3, user: clerk)
  wf3.submit!
  wf3.reject!
end

puts "✅ Documents and Workflows Seeded Successfully!"
