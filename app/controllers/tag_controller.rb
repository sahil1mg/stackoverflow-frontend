class TagController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update]

  def index
    @tags = JSON.parse(TagService.showAll.body)
    @question_count = JSON.parse(TagService.get_question_count_for_tags.body)
  end

  def show
    @tag = JSON.parse(TagService.show(params[:id]).body)
    @questions = JSON.parse(TagService.get_questions_for_tag(params[:id]).body)
    @count_of_answers = JSON.parse(AnswerService.get_count_of_answers(@questions).body)
  end

  def create
    puts "Started Create tag"
    @tag = tag_params
    @response = TagService.create(@tag)
    if (@response && @response.code == '201')
      @tag = JSON.parse(@response.body)
      flash.now[:success] = "tag created successfully!"
      redirect_to tag_path(@tag["id"])
    else
      flash[:danger] = @response.body
      redirect_to new_tag_path
    end
  end

  def edit
    @tag = JSON.parse(TagService.show(params[:id]).body)
  end

  def update
    puts "Started Update tag"+tag_params.to_s
    @tag = tag_params
    @response = TagService.update(@tag)
    if (@response && @response.code == '200')
      puts "success"
      @tag = JSON.parse(@response.body)
      flash.now[:success] = "tag created successfully!"
      redirect_to tag_path(@tag["id"])
    else
      puts "failure"
      flash[:danger] = @response.body
      redirect_to edit_tag_path
    end
  end

  def destroy
    puts "Started Deleted tag"+tag_params.to_s
    @tag = tag_params
    response = TagService.destroy(@tag["id"])
    if (response && response.code == '200')
      puts "success"
      flash[:success] = "tag deleted successfully!"
    else
      puts "failure"
      flash[:danger] = "Something went wrong"
    end
    redirect_to request.referrer || root_url
  end

  private
  def tag_params
    params.permit(:label,:body, :id)
  end
end
