class CommentController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update]
  def create
    puts "Started Create comment"
    @comment = comment_params
    @comment[:user_id]=current_user["user_id"]
    @response = CommentService.create(@comment)
    question_id=@comment["question_id"]
    redirect_to question_path(question_id)
  end

  def edit
  end

  def update
    puts "Started Update comment"+comment_params.to_s
    @comment = comment_params
    question_id=@comment["question_id"]
    @response = CommentService.update(@comment)
    if (@response && @response.code == '200')
      puts "success"
      @comment = JSON.parse(@response.body)
      flash.now[:success] = "comment updated successfully!"
    else
      puts "failure"
      flash[:danger] = @response.body
    end
    redirect_to question_path(question_id)
  end

  private

  def comment_params
    params.permit(:id, :commentable_id, :commentable_type, :text, :question_id)
  end
end
