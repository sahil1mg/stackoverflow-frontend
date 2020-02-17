class QuestionController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update]

  def index
    @questions = JSON.parse(QuestionService.showAll.body)
    @count_of_answers = JSON.parse(AnswerService.get_count_of_answers(@questions).body)
  end

  def new
    #get tags to select when creating questions
    @tags = JSON.parse(TagService.showAll.body)
  end

  def show
    @question = QuestionService.show(params[:id]);
    if (@question.code=='200')
      @question = JSON.parse(@question.body)
      @answers = JSON.parse(AnswerService.show_by_question_id(params[:id]).body)
      @votes = []
      if logged_in?
        votes = JSON.parse(VoteService.get_user_vote_data(params[:id], current_user["user_id"]).body)
        @vote_ids = VoteService.create_voted_ids(votes)
      end
    else
      redirect_to static_pages_page_not_found_path
    end
  end

  def create
    puts "Started Create Question"
    @question = question_params
    @question["user_id"]=current_user["user_id"]
    @question["remember"]=current_user["remember"]
    @response = QuestionService.create(@question)
    if (@response && @response.code == '201')
      @question = JSON.parse(@response.body)
      flash.now[:success] = "Question created successfully!"
      redirect_to question_path(@question["id"])
    else
      flash[:danger] = @response.body
      redirect_to new_question_path
    end
  end

  def edit
    @question = JSON.parse(QuestionService.show(params[:id]).body)
    @tags = JSON.parse(TagService.showAll.body)
  end

  def update
    puts "Started Update Question"+question_params.to_s
    @question = question_params
    @response = QuestionService.update(@question)
    if (@response && @response.code == '200')
      puts "success"
      @question = JSON.parse(@response.body)
      flash.now[:success] = "Question created successfully!"
      redirect_to question_path(@question["id"])
    else
      puts "failure"
      flash[:danger] = @response.body
      redirect_to edit_question_path
    end
  end

  def destroy
    puts "Started Delete question"+question_params.to_s
    @question = question_params
    response = QuestionService.destroy(@question["id"])
    if (response && response.code == '200')
      puts "success"
      flash[:success] = "question deleted successfully!"
    else
      puts "failure"
      flash[:danger] = "Something went wrong"
    end
    redirect_to root_url
  end

  def restore
    puts "Started restore question"+question_params.to_s
    @question = question_params
    response = QuestionService.restore(@question["id"])
    if (response && response.code == '200')
      puts "success"
      flash.now[:success] = "question restored successfully!"
    else
      puts "failure"
      flash.now[:danger] = "Something went wrong"
    end
    redirect_to request.referer || root_url
  end

  private

  def question_params
    params.permit("title","body", "id", "tags"=>[])
  end
end
