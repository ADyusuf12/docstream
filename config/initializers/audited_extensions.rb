ActiveSupport.on_load(:active_record) do
  if defined?(Audited::Audit)
    Audited::Audit.include(Exportable)
  end
end
