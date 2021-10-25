require './user'

class Dealer < User
  attr_reader :actions

  def initialize
    super(@name)
    @name = dealer_name
    @actions = dealer_actions
  end

  def dealer_actions
    ['skip', 'add card']
  end

  def reset_action
    @actions = dealer_actions
  end

  def remove_action(user_action)
    @actions.delete_if { |action| action == user_action }
  end

  def dealer_name
    'Dealer'
  end
end
