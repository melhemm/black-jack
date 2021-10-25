class Card
  FACES = %w[2 3 4 5 6 7 8 9 10 J Q K A]
  SUITS = %w[♣ ♥ ♠ ♦]

  attr_reader :name, :value, :face

  def initialize(args = {})
    @face = args[:face]
    @suit = args[:suit]
    @name = create_name
    @value = set_value
  end

  def create_name
    @face + @suit
  end

  def set_value
    return 10 if %w[J Q K].include?(@face)
    return 11 if @face == 'A'

    @face.to_i
  end
end
