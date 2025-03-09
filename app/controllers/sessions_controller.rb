class SessionsController < ApplicationController
  def new
    @user = User.new # This initializes an empty user object.
  end

  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    # Clear the current user as well
    user = nil
    redirect_to root_url, status: :see_other
  end
end
