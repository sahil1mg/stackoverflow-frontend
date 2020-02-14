class StaticPagesController < ApplicationController

  TAG_REGEX=/^\[\w+\]$/
  USER_REGEX=/^user:/

  def page_not_found
  end

  def search
    puts params[:search]
    @search_query = params[:search]
    if(@search_query.match TAG_REGEX)
      response=TagService.search(@search_query)
      if(response && response.code=='302')
        redirect_to tag_path(JSON.parse(response.body).first["id"])
      end
    elsif(@search_query.match USER_REGEX)
      response=UserService.search(@search_query)
      if(response && response.code=='302')
        redirect_to user_path(JSON.parse(response.body).first["id"])
      end
    else
      response = QuestionService.search(@search_query)
      if(response && response.code=='302')
        @questions = JSON.parse(response.body)
        @count_of_answers = JSON.parse(AnswerService.get_count_of_answers(@questions).body)
      end
    end
  end
end
