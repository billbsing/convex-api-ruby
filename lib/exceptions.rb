

class Convex::RequestError < StandardError
  def initialize(request)
    @code = request.code
    super(request.message)
  end
end
