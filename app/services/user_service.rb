class UserService

  def self.showAll
    response = Net::HTTP.get_response('localhost', '/user',3000)
  end

  def self.get(id)
    if(id!=nil )
      response = Net::HTTP.get_response('localhost', '/user/'+id.to_s,3000)
    end
  end

  def self.create(user)
    uri = URI('http://localhost:3000/user');
    puts user.to_json
    req = Net::HTTP::Post.new(uri)
    req.body = user.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.update(user)
    res=nil
    uri = URI('http://localhost:3000/user/'+user["id"]);
    puts "Started Updated"
    puts user.to_json
    req = Net::HTTP::Put.new(uri)
    req.body = user.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    puts res
    return res
  end

  def self.search(search_query)
    uri = URI('http://localhost:3000/search_user');
    req = Net::HTTP::Post.new(uri)
    req.body = {:search=>search_query[5..-1]}.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.destroy(id)
    res=nil
    uri = URI('http://localhost:3000/user/'+id.to_s);
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Delete.new(uri.path)
    res = http.request(req)
    return res
  end

end