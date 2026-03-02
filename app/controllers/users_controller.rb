class UsersController < ApplicationController
  before_action :authenticate_user!

  def update_role
    target_user = User.find_or_create_by!(email: "#{params[:role]}@tirs.gov.ng") do |u|
      u.password = "password123"
      u.role = params[:role]
    end

    # Log out the current user and log in as the target persona
    sign_out(current_user)
    sign_in(target_user)

    redirect_to root_path, notice: "Switched to #{params[:role].upcase} Persona."
  end
end
