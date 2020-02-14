class QuestionService
  require 'json'
  def self.showAll
    response = Net::HTTP.get_response('localhost', '/',3000)
  end

  def self.show(id)
    response = Net::HTTP.get_response('localhost', '/question/'+id,3000)
  end

  def self.get_answered_questions(id)
    response = Net::HTTP.get_response('localhost', '/question/answered_questions/'+id,3000)
  end

  def self.create(question)
    uri = URI('http://localhost:3000/question');
    puts question.to_json
    req = Net::HTTP::Post.new(uri)
    req.body = question.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.update(question)
    res=nil
    uri = URI('http://localhost:3000/question/'+question["id"]);
    puts question.to_json
    req = Net::HTTP::Put.new(uri)
    req.body = question.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    puts res
    return res
  end

  def self.search(search_query)
    uri = URI('http://localhost:3000/search_question');
    req = Net::HTTP::Post.new(uri)
    req.body = {:search=>search_query}.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

end
