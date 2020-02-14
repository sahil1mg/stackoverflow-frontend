class TagService

  def self.showAll
    response = Net::HTTP.get_response('localhost', '/tag',3000)
  end

  def self.show(id)
    response = Net::HTTP.get_response('localhost', '/tag/'+id,3000)
  end

  def self.get_questions_for_tag(id)
    response = Net::HTTP.get_response('localhost', '/tag/'+id+'/questions',3000)
  end

  def self.get_question_count_for_tags
    response = Net::HTTP.get_response('localhost', '/tag_question_count/',3000)
  end

  def self.create(tag)
    uri = URI('http://localhost:3000/tag');
    puts tag.to_json
    req = Net::HTTP::Post.new(uri)
    req.body = tag.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.update(tag)
    res=nil
    uri = URI('http://localhost:3000/tag/'+tag["id"]);
    puts tag.to_json
    req = Net::HTTP::Put.new(uri)
    req.body = tag.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    puts res
    return res
  end

  def self.destroy(id)
    res=nil
    uri = URI('http://localhost:3000/tag/'+id.to_s);
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Delete.new(uri.path)
    res = http.request(req)
    return res
  end

  def self.search(search_query)
    uri = URI('http://localhost:3000/search_tag');
    req = Net::HTTP::Post.new(uri)
    req.body = {:search=>search_query[1..-2]}.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

end