class SessionsController < ApplicationController
  def new
  end

  def create
    respond_to do |format| #if respond_to is used then format has to be used to get next page
      response = SessionService.authenticate(params)
      if response.code == '200'
        user = JSON.parse(response.body)
        puts user.to_s
        log_in user
        session_params[:remember_me] == '1' ? remember(user["id"], user["remember"]) : forget
        flash.now[:success]="Welcome "+user["name"]
        format.html{ redirect_back_or(root_url)}
      elsif(response.code == '401')
        flash.now[:danger]="Wrong Username and password"
        format.html{ render 'new'}
      else
        flash.now[:danger]="Something went wrong"
        format.html{ render 'new'}
      end
    end
  end

  def destroy
    user_id = current_user["user_id"]
    log_out
    SessionService.logout(user_id)
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit("email_id", "password", "remember_me")
  end

end