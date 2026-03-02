# Users
User.create!(email: "admin@docstream.com", password: "password", role: :admin)
User.create!(email: "clerk@docstream.com", password: "password", role: :clerk)
User.create!(email: "approver@docstream.com", password: "password", role: :approver)

clerk    = User.find_by(email: "clerk@docstream.com")

# Documents with attached files
doc1 = clerk.documents.create!(title: "Tax Memo Draft")
doc1.files.attach(io: File.open(Rails.root.join("demo_docs/tax_memo.pdf")), filename: "tax_memo.pdf")
doc1.versions.create!(content: "Initial draft of tax memo.", ai_generated: false)

doc2 = clerk.documents.create!(title: "Client Letter")
doc2.files.attach(io: File.open(Rails.root.join("demo_docs/client_letter.pdf")), filename: "client_letter.pdf")
doc2.versions.create!(content: "Initial draft of client letter.", ai_generated: false)

doc3 = clerk.documents.create!(title: "Internal Policy Note")
doc3.files.attach(io: File.open(Rails.root.join("demo_docs/policy_note.pdf")), filename: "policy_note.pdf")
doc3.versions.create!(content: "Draft of remote work guidelines.", ai_generated: false)

doc4 = clerk.documents.create!(title: "Rejected Draft")
doc4.files.attach(io: File.open(Rails.root.join("demo_docs/rejected_draft.pdf")), filename: "rejected_draft.pdf")
doc4.versions.create!(content: "Incomplete draft report.", ai_generated: false)

# Workflows
wf1 = WorkflowInstance.create!(document: doc1, user: clerk)
wf1.submit!   # pending

wf2 = WorkflowInstance.create!(document: doc2, user: clerk)
wf2.submit!
wf2.approve!  # approved

wf3 = WorkflowInstance.create!(document: doc3, user: clerk)
wf3.submit!
wf3.reject!   # rejected

wf4 = WorkflowInstance.create!(document: doc4, user: clerk)
wf4.submit!   # pending

# AI-generated versions for demo
doc1.versions.create!(content: "AI-generated summary of Tax Memo: Highlights proposed changes to filing deadlines and digital submission requirements.", ai_generated: true)
doc2.versions.create!(content: "AI-generated client letter draft: Polished update with clear next steps and professional tone.", ai_generated: true)
