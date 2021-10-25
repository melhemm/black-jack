require './card'

class Deck
  attr_reader :cards

  def initialize
    @faces = faces_array
    @suits = suits_array
    @cards = build_deck
  end

  def show_deck
    @cards.each(&:name)
  end

  def take_card
    @cards.pop
  end

  def build_deck
    cards = []
    @faces.each do |face|
      @suits.each do |suit|
        cards << Card.new(face: face, suit: suit)
      end
    end
    cards.shuffle!
  end

  def faces_array
    Card::FACES
  end

  def suits_array
    Card::SUITS
  end
end
