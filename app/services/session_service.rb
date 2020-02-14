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

  end