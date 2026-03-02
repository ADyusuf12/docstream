module Admin
  class AuditsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def index
      @audits = Audited::Audit.order(created_at: :desc)
      respond_to do |format|
        format.html
        format.csv { send_data @audits.to_csv, filename: "audits-#{Date.today}.csv" }
      end
    end

    private

    def authorize_admin!
      redirect_to root_path, alert: "Not authorized" unless current_user.admin?
    end
  end
end
