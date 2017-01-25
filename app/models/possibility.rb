class Possibility
  include ActiveAttr::Model

  attribute :championships
  attribute :best_brackets

  def ==(other)
    other.class == self.class && other.state == state
  end

  alias eql? ==

  delegate :hash, to: :state

  protected

  def state
    championships.to_a + best_brackets.to_a
  end
end
