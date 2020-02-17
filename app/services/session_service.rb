class SessionService

  def self.authenticate(user)
    uri = URI('http://localhost:3000/session/authenticate');
    puts user.to_json
    req = Net::HTTP::Post.new(uri)
    req.body = user.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.logout(id)
    res=nil
    uri = URI('http://localhost:3000/logout/'+id.to_s);
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Delete.new(uri.path)
    res = http.request(req)
    return res
  end
end