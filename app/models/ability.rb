class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #guests

    if user.admin?
      can :manage, :all
    else
      can :manage, User do |action, user_to_manage|
        user_to_manage == user || user_to_manage.editors.include?(user)
      end

      can :manage, Profile do |action, profile|
        profile.user == user
      end

      can :manage, Restaurant do |action, restaurant|
        restaurant.try(:manager) == user || restaurant.managers.include?(user)
      end

      can :manage, Discussion do |action, discussion|
        discussion && discussion.poster == user || discussion.users.include?(user)
      end

      can :manage, Admin::Conversation do |action, conversation|
        conversation.try(:recipient) == user
      end

      can :manage, AdminDiscussion do |action, discussion|
        discussion.restaurant && discussion.discussionable && discussion.discussionable.viewable_by?(
          discussion.restaurant.employments.find_by_employee_id(user.id)
        )
      end

      can :manage, MediaRequest do |action, message|
        message.sender == user
      end

      can :manage, MediaRequestDiscussion do |action, discussion|
        discussion.viewable_by?(discussion.restaurant.employments.find_by_employee_id(user.id))
      end

      can :manage, SoloMediaDiscussion do |action, discussion|
        discussion.employee == user
      end
    end
  end

end