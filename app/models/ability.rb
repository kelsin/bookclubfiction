class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can :manage, :all
      can :search, :all
    end

    if user && user.member?
      can :search, :all
      can :view, :all
    end
  end
end
