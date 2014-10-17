class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.member?
      can [:search, :read], :all
      cannot [:search, :read], User

      can :create, Nomination, :user_id => user.id, :admin => false
      can [:vote, :unvote], Nomination

      can [:create, :destroy], Selection, :user_id => user.id
    end

    if user && user.admin?
      can :manage, :all
    end
  end
end
