class Ability
  include CanCan::Ability

  def initialize(user)
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    case user.role
    when "admin"
      can :manage, :all
    when "curador"
      can [:read, :create, :update, :preview, :log], Neuron
      cannot [:delete, :restore], Neuron
      can :search, Content
    end
  end
end
