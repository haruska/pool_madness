class Ability
  include CanCan::Ability

  def initialize(user, pool=nil)
    user ||= User.new # guest user (not logged in)
    pool ||= Pool

    can(:manage, :all) if user.has_role?(:admin)

    if user.id.present?
      can :manage, User, id: user.id
      can [:index, :read], Charge, bracket: { user_id: user.id }
      can :read, Game

      if pool.started?
        can :read, Bracket
        cannot [:create, :update], Bracket
        cannot :destroy, Bracket unless user.has_role?(:admin)
      else
        can :manage, Bracket, user_id: user.id
        can :update, Pick, bracket: { user_id: user.id }
        cannot :destroy, Bracket.where("id IN (select bracket_id from charges)")
      end
    end
  end
end
