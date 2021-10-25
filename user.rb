require './bank'
require './hand'

class User < Hand
  include Bank

  attr_accessor :hand, :bank
  attr_reader :name

  def initialize(name)
    @name = name
    @hand = []
    @bank = 100
  end

  def user_hand(_flag = false)
    if name == 'Dealer'
      "#{name} #{hand.map { '*' }.join} points **"
    else
      "#{name} #{cards} points #{points}"
    end
  end

  HAND_LIMIT = 3

  def hand_limit?
    hand.length == HAND_LIMIT
  end

  def clear_hand
    self.hand = []
  end
end
