require './user'

class Player < User
  attr_reader :actions, :bank

  def initialize(name)
    super(name)
    @name = name
    @actions = player_actions
  end

  def remove_action(user_action)
    @actions.delete_if { |action| action == user_action }
  end

  def reset_action
    @actions = player_actions
  end

  def player_actions
    ['skip', 'add card', 'open cards']
  end
end
