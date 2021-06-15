

class Convex::APIError < StandardError
  attr_reader :code, :value
  def initialize(code, value)
    @code = code
    @value = value
    super(message)
  end

  def message()
    "#{@code}: #{@value}"
  end
end
