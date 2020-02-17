class UserController < ApplicationController
  before_action :logged_in_user, only: [:update, :destroy]
  before_action :is_admin?, only: [:destroy]
  def index
    @user = JSON.parse(UserService.showAll.body)
  end

  def show
    user_response = UserService.get(params[:id])
    if(user_response.code=='200')
      @user = JSON.parse(user_response.body)
      @answered_questions = JSON.parse(QuestionService.get_answered_questions(params[:id]).body)
      @count_of_answers = JSON.parse(AnswerService.get_count_of_answers(@user["questions"]).body)
    else
      #render html: user_response.body
      redirect_to static_pages_page_not_found_path
    end
  end

  def new
  end

  # POST /users
  # POST /users.json
  def create
    @user = UserService.create(user_params)
    if (@user && @user.code == '201')
      @user = JSON.parse(@user.body)
      log_in @user
      flash.now[:success] = "User created successfully!"
      redirect_to user_path(@user["id"])
    else
      flash[:danger] = @user.body
      redirect_to new_user_path
    end
  end

  def edit
    @user = JSON.parse(UserService.get(params[:id]).body)
  end

  def update
    user = user_params
    @response = UserService.update(user)
    if (@response && @response.code == '200')
      puts "success"
      user = JSON.parse(@response.body)
      flash.now[:success] = "Question created successfully!"
      redirect_to user_path(user["id"])
    else
      puts "failure"
      flash[:danger] = @response.body
      redirect_to edit_user_path
    end
  end

  def destroy
    puts "Started Delete user"+user_params.to_s
    @user = user_params
    response = UserService.destroy(@user["id"])
    if (response && response.code == '200')
      puts "success"
      log_out if current_user?(@user)
      flash[:success] = "user deleted successfully!"
    else
      puts "failure"
      flash[:danger] = "Something went wrong"
    end
    redirect_to request.referrer || root_url
  end

  private

  def user_params
    params.permit("name", "email_id", "password", "password_confirmation", "id")
  end

  # Confirms an admin user.
  def is_admin?
    redirect_to(root_url) unless (current_user && current_user[:is_admin])
  end
end
