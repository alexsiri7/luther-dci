class Luther::DCI::Role < SimpleDelegator
  attr_reader :context
  alias :player :__getobj__
  def initialize context, data
    super data
    @context = context
  end

  def class
    return player.class
  end
end
