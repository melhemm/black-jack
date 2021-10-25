require './player'
require './dealer'
require './deck'
require './bank'

class Game
  include Bank

  attr_accessor :player, :dealer, :dealer_action_text

  def initialize(player_name)
    @bank = 0
    @player = Player.new(player_name)
    @dealer = Dealer.new
  end

  def start
    @deck = Deck.new
    @player.reset_action
    @dealer.reset_action
    card_division
    bank_contribution
    @finish = false
  end

  def stop?
    @finish
  end

  def next?
    @next
  end

  def actions
    txt = "\n#{@player.name}, choose: \n"
    @player.actions.each_with_index do |action, index|
      txt += "#{index} - #{action}\n"
    end
    txt
  end

  def define_choice(action)
    @player.actions[action.to_i]
  end

  def player_summary
    @player.user_hand.to_s
  end

  def dealer_summary(flag)
    @dealer.user_hand(flag).to_s
  end

  def user_action(action)
    return @finish = true if hand_limit_reached?

    @next = false

    case action
    when 'skip'
      skip_action
    when 'add card'
      add_card
    when 'open cards'
      @finish = true
    else
      @next = true
    end
  end

  def bank
    "#{@player.name} balance: #{@player.bank}\nDealer balance: #{@dealer.bank}"
  end

  def card_division
    @player.clear_hand
    @dealer.clear_hand
    2.times { take_card(@player) }
    2.times { take_card(@dealer) }
  end

  def bank_contribution
    contribute_to_game_bank(@player, 10)
    contribute_to_game_bank(@dealer, 10)
  end

  def take_card(user)
    user.hand << @deck.take_card
  end

  def contribute_to_game_bank(user, sum)
    user.reduce_value(sum)
    increase_value(sum)
  end

  def hand_limit_reached?
    @player.hand_limit? && @dealer.hand_limit?
  end

  def skip_action
    @player.remove_action('skip')
  end

  def add_card
    return if @player.hand.length > 2

    take_card(@player)
    @player.remove_action('add card')
  end

  def dealer_add_card
    return unless @dealer.hand.length == 2

    @dealer_action_text = "\n Dealer took a card!\n"
    take_card(@dealer)
  end

  def points_equal?
    @player.points == @dealer.points
  end

  BLACKJACK = 21

  def player_win?
    (@player.points > @dealer.points && points_in_boards?) ||
      (@dealer.points > BLACKJACK && @player.points <= BLACKJACK)
  end

  def dealer_win?
    (@dealer.points > @player.points && points_in_boards?) ||
      (@dealer.points <= BLACKJACK && @player.points > BLACKJACK)
  end

  def dealer_action
    return @finish = true if hand_limit_reached? || @dealer.points == BLACKJACK

    if @dealer.points >= 17 && @dealer.actions.include?('skip')
      @dealer_action_text = "\n Dealer skip \n"
      @dealer.remove_action('skip')
    else
      dealer_add_card
    end
  end

  def specify_winner
    if player_win?
      reward_winner(@player)
      'player win'
    elsif dealer_win?
      reward_winner(@dealer)
      'dealer win'
    elsif points_equal?
      reward_users
      'the sum of the points is the same'
    else
      'No winner'
    end
  end

  def user_bankrupt?
    @player.bank.zero? || @dealer.bank.zero?
  end

  def points_in_boards?
    @dealer.points <= BLACKJACK && @player.points <= BLACKJACK
  end

  def reward_users
    @dealer.increase_value(@bank / 2)
    @player.increase_value(@bank / 2)
    reduce_value(@bank)
  end

  def reward_winner(winner)
    winner.increase_value(@bank)
    reduce_value(@bank)
  end
end
