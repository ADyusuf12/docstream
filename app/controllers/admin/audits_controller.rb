# app/controllers/admin/audits_controller.rb
module Admin
  class AuditsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def index
      # Added .includes(:user) to prevent the "N+1" performance bug
      # (fetching the user for every single row individually)
      @audits = Audited::Audit.includes(:user).order(created_at: :desc).page(params[:page]).per(20)



      respond_to do |format|
        format.html
        format.csv do
          require "csv"
          csv_data = CSV.generate(headers: true) do |csv|
            # Define headers for the Chairman's report
            csv << [ "Timestamp", "Authorized Actor", "Event", "Resource", "Detailed Changes" ]

            @audits.each do |audit|
              csv << [
                audit.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                audit.user&.email || (audit.username == "AI Intelligence Engine" ? "AI Engine" : "System Process"),
                audit.action.upcase,
                "#{audit.auditable_type} ##{audit.auditable_id}",
                audit.audited_changes.to_json
              ]
            end
          end
          send_data csv_data, filename: "TIRS-Forensic-Audit-#{Date.today}.csv"
        end
      end
    end

    private

    def authorize_admin!
      redirect_to root_path, alert: "Not authorized" unless current_user.admin?
    end
  end
end
