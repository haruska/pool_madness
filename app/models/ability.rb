class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    end

    if user.id.present?
      can :manage, User, :id => user.id
      can [:index, :read], Charge, :bracket => {:user_id => user.id}
      can :read, Game

      if Pool.started?
        can :read, Bracket
        cannot [:create, :update], Bracket
        cannot :destroy, Bracket unless user.has_role?(:admin)
      else
        can :manage, Bracket, :user_id => user.id
        can :update, Pick, :bracket => { :user_id => user.id }
        cannot :destroy, Bracket.where('id IN (select bracket_id from charges)')
      end
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
