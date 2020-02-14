class AnswerService
  require 'json'

  def self.create(answer)
    puts "Started Answer create service"
    uri = URI('http://localhost:3000/answer');
    puts answer.to_json
    req = Net::HTTP::Post.new(uri)
    req.body = answer.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.update(answer)
    res=nil
    uri = URI('http://localhost:3000/answer/'+answer["id"]);
    puts answer.to_json
    req = Net::HTTP::Put.new(uri)
    req.body = answer.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.show(id)
    response = Net::HTTP.get_response('localhost', '/answer/'+id,3000)
  end

  def self.show_by_question_id(id)
    response = Net::HTTP.get_response('localhost', '/answer/question/'+id,3000)
  end

  def self.get_count_of_answers(questions)
    uri = URI('http://localhost:3000/answer_count');
    req = Net::HTTP::Post.new(uri)
    ids = []
    if(!questions.nil?)
      ids= questions.pluck("id")
    end
    req.body = {:ids=>ids}.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end
end