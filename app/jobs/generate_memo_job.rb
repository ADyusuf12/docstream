class GenerateMemoJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find_by(id: document_id)
    return unless document

    sleep(4) # Simulate AI Processing

    is_suspicious = [ true, false ].sample

    if is_suspicious
      ai_content = "⚠️ RISK ALERT: #{document.title}\n\nLinguistic pattern analysis suggests a potential discrepancy in reported revenue figures."
      risk_level = "High"
      confidence = 0.84
      entities = [ "Revenue Audit Unit", "Suspicious Entry" ]
    else
      ai_content = "✅ EXECUTIVE BRIEF: #{document.title}\n\nDocument is fully consistent with official Taraba State internal revenue standards."
      risk_level = "Low"
      confidence = 0.98
      entities = [ "Taraba State Government", "TIRS Finance Dept" ]
    end

    # Explicitly attribute this action to the AI actor in the audit trail
    version = nil
    Audited.audit_class.as_user("AI Intelligence Engine") do
      version = document.versions.create!(
        content: ai_content,
        ai_generated: true,
        metadata: {
          "risk_score" => risk_level,
          "confidence" => confidence,
          "entities" => entities,
          "generated_at" => Time.current.to_s
        }
      )
    end

    # Broadcast to the AI Section (Center)
    document.broadcast_update_to(
      "document_status_#{document.id}",
      target: "ai_section",
      partial: "documents/ai_result",
      locals: { version: version }
    )

    # Broadcast to the Audit Log (Sidebar)
    # We grab the last audit because 'as_user' populated the username field there
    new_audit = version.audits.last
    if new_audit
      document.broadcast_prepend_to(
        "document_status_#{document.id}",
        target: "audit_log_container",
        partial: "workflow_instances/audit_entry",
        locals: { audit: new_audit }
      )

      # Clean up the "No audit history" message if it's there
      document.broadcast_remove_to(
        "document_status_#{document.id}",
        target: "empty_audit_msg"
      )
    end
  end
end
