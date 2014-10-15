class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can :manage, :all
      can :search, :all
    end

    if user && user.member?
      can :search, :all
      can :read, :all

      can :create, Nomination, :user_id => user.id, :admin => false
      can :create, Selection, :user_id => user.id
      can :vote, Nomination
      can :unvote, Nomination
    end
  end
end
