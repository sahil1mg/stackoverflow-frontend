class AnswerController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update]

  def create
    puts "Started Create Answer"
    @answer = answer_params
    @answer[:user_id]=current_user["user_id"]
    @answer[:remember]=current_user["remember"]
    @response = AnswerService.create(@answer)
    question_id=@answer["question_id"]
    if (@response && @response.code == '201')
      @answer = JSON.parse(@response.body)
      flash.now[:success] = "Answer created successfully!"
    else
      flash.now[:danger] = @response.body
    end
    redirect_to question_path(question_id)
  end

  def edit
    @answer = JSON.parse(AnswerService.show(params[:id]).body)
  end

  def update
    puts "Started Update answer"+answer_params.to_s
    @answer = answer_params
    question_id=@answer["question_id"]
    @response = AnswerService.update(@answer)
    if (@response && @response.code == '200')
      puts "success"
      @answer = JSON.parse(@response.body)
      flash.now[:success] = "Answer updated successfully!"
      redirect_to question_path(question_id)
    else
      puts "failure"
      flash[:danger] = @response.body
      redirect_to edit_answer_path(@answer["id"])
    end
  end

  def destroy
    puts "Started Delete Answer"+answer_params.to_s
    @answer = answer_params
    response = AnswerService.destroy(@answer["id"])
    if (response && response.code == '200')
      puts "success"
      flash.now[:success] = "Answer deleted successfully!"
    else
      puts "failure"
      flash.now[:danger] = "Something went wrong"
    end
    redirect_to user_path(current_user["user_id"])
  end

  def restore
    puts "Started restore Answer"+answer_params.to_s
    @answer = answer_params
    response = AnswerService.restore(@question["id"])
    if (response && response.code == '200')
      puts "success"
      flash.now[:success] = "Answer restored successfully!"
    else
      puts "failure"
      flash.now[:danger] = "Something went wrong"
    end
    redirect_to request.referer || root_url
  end
  
  private
  def answer_params
    params.permit(:text,:question_id, :id)
  end
end
