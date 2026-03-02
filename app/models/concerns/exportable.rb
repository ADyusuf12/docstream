require "csv"

module Exportable
  extend ActiveSupport::Concern

  class_methods do
    def to_csv
      # Selecting attributes aligned with the TIRS technical appendix
      attributes = %w[id created_at action auditable_type user_id remote_address]

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.each do |record|
          csv << attributes.map { |attr| record.send(attr) }
        end
      end
    end
  end
end
