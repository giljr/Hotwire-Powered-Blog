class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_current_user

  def set_current_user
    if session[:user_id]
      Current.user = User.find_by(id: session[:user_id])
      # @user = User.find(session[:user_id])
      # The 'find' method raises an 'ActiveRecord::RecordNotFound' exception if no record is found.
    end
  end

  def require_user_logged_in
    redirect_to sign_in_path, alert: "You must be logged in to do this." if Current.user.nil?
  end
end
