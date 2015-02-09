class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here.
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    case user.role
    when "admin"
      can :manage, :all
    when "curador"
      can [:read, :create], Neuron
    end
  end
end
