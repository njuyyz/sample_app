class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        # log the user in and redirect to the user's show page.
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = "Account not activated yet."
        message += " Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      #create an error message.
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    flash[:success] = "Logged out successfully"
    log_out if logged_in?
    redirect_to root_path
  end
end
