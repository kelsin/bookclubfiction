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

      can :create, Nomination, :user_id => user.id
      can :manage, Vote, :user_id => user.id
    end
  end
end
