require './game'

class MainInterface
  def initialize
    @player_name = player_name
    @game = Game.new(@player_name)
  end

  def play
    loop do
      start_game
      run_game
      finish_game(@winner)
      break if exit_game || @game.user_bankrupt?
    end
  end

  def player_name
    puts 'enter your name to start the game'
    gets.chomp
  end

  def start_game
    @game.start
    puts users_summary(false)
  end

  def run_game
    loop do
      user_plays
      if @game.next?
        puts 'Action is not available!'
        next
      else
        puts @game.player_summary
      end
      break if stop?

      dealer_plays
      break if stop?
    end
    @winner = @game.specify_winner
  end

  def users_summary(flag)
    puts @game.player_summary
    puts @game.dealer_summary(flag)
  end

  def choose_action
    puts @game.actions
    gets.chomp
  end

  def user_plays
    action = @game.define_choice(choose_action)
    @game.user_action(action)
  end

  def dealer_plays
    puts "\nDealer plays...\n"
    @game.dealer_action
    puts @game.dealer_action_text
    puts @game.dealer_summary(false)
  end

  def stop?
    @game.stop?
  end

  def finish_game(result)
    puts "\nGame results: \n"
    puts users_summary(true)
    show_bank
    puts result.to_s
  end

  def show_bank
    puts @game.bank
  end

  def exit_game
    puts 'enter any key to restart or enter 0 to exit'
    gets.chomp.to_i == 0
  end
end
