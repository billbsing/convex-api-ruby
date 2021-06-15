

class Convex::RequestError < StandardError
  def initialize(response)
    puts(response.code, response.body)
    @code = response.code
    super(response.body)
  end
end

class Convex::APIError < StandardError
  def initialize(code, value)
    @code = code
    @value = value
    super(message)
  end

  def message()
    "#{@code}: #{@value}"
  end
end
