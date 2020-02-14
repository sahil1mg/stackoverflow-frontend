class VoteController < ApplicationController
  before_action :logged_in_user

  def create
    @vote = vote_params
    @vote["user_id"] =current_user["user_id"]
    response = VoteService.create(@vote)
    if(response.code=="200")
      @vote_count=response.body
    end
    respond_to do |format|
      format.html { redirect_to question_path(@vote["question_id"]) }
      format.js
    end
  end

  private

  def vote_params
    params.permit("id", "has_liked", "votable_type", "votable_id")
  end
end
