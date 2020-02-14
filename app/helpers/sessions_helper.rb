module SessionsHelper

  def log_in(user)
    session[:user_id]=user["id"]
    session[:name]=user["name"]
    session[:email]=user["email_id"]
    session[:is_admin]=user["is_admin"]
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (session[:user_id])
      if(@current_user==nil)
        @current_user ||= session
      end
    end
    return session
  end

  def current_user?(user)
    current_user[:user_id] == user["id"]
  end

  def logged_in?
    session[:user_id]
  end

  def is_admin?
    session[:is_admin]
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  #Storing last url if user wanted to open an url but couldn't as he/she was not logged
  def store_location
    puts request #checking what it has
    session[:forwarding_url] = request.original_url if request.get?
  end

  #friendly forwarding
  def redirect_back_or(default)
    redirect_to session[:forwarding_url] || default # checks if first is not nil then first else default
    session.delete(:forwarding_url)
  end
end
