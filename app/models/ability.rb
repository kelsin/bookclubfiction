class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can [:manage, :search], :all
    end

    if user && user.member?
      can [:search, :read], :all

      can :create, Nomination, :user_id => user.id, :admin => false
      can [:vote, :unvote], Nomination

      can [:create, :destroy], Selection, :user_id => user.id
    end
  end
end
