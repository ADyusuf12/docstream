# app/models/workflow_instance.rb
class WorkflowInstance < ApplicationRecord
  include AASM

  belongs_to :document
  belongs_to :user

  # Enables the .audits method to track status changes for the demo history
  audited

  aasm do
    state :draft, initial: true
    state :pending, :approved, :rejected

    event :submit do
      transitions from: :draft, to: :pending
    end

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    # Automatically triggers live updates across all connected browsers
    after_all_transitions :broadcast_status_change
  end

  private

  def broadcast_status_change
    # 1. Update the 'Show' page (targets the single global status_badge ID)
    document.broadcast_replace_to(
      "document_status_#{document.id}",
      target: "status_badge",
      partial: "shared/status_badge",
      locals: { state: aasm.to_state }
    )

    # 2. Update the 'Index' page (targets the document-specific ID in the table)
    document.broadcast_replace_to(
      "document_status_#{document.id}",
      target: "status_badge_#{document.id}",
      partial: "shared/status_badge",
      locals: { state: aasm.to_state }
    )
  end
end
