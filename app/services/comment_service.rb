class CommentService
  require 'json'

  def self.create(comment)
    uri = URI('http://localhost:3000/comment');
    puts comment.to_json
    req = Net::HTTP::Post.new(uri)
    req.body = comment.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end

  def self.update(comment)
    res=nil
    uri = URI('http://localhost:3000/comment/'+comment["id"]);
    puts comment.to_json
    req = Net::HTTP::Put.new(uri)
    req.body = comment.to_json
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return res
  end
end