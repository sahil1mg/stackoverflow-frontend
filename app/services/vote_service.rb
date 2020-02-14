class VoteService

  def self.create(vote)
    uri = URI('http://localhost:3000/vote');
    puts vote.to_json
    req = Net::HTTP::Post.new(uri)
    req.body = vote.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.get_user_vote_data(question_id, user_id)
    data = {:question_id=> question_id, :user_id=> user_id}
    uri = URI('http://localhost:3000/vote_data');
    req = Net::HTTP::Post.new(uri)
    req.body = data.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.create_voted_ids(votes)
    vote_ids = {}
    if(!votes.nil?)
      votes.each do |vote|
        if(vote["has_liked"])
          vote_ids['upvote_'+vote["votable_type"]+'_'+vote["votable_id"].to_s]=vote["has_liked"]
        else
          vote_ids['downvote_'+vote["votable_type"]+'_'+vote["votable_id"].to_s]=vote["has_liked"]
        end
      end
    end
    return vote_ids
  end

end