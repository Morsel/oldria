class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #guests

    if user.admin?
      can :manage, :all
    else
      can :manage, User do |user_to_manage,action|
        user_to_manage == user || user_to_manage.editors.include?(user)
      end

      can :manage, Profile do |profile,action |
        profile.user == user
      end

      can :manage, Restaurant do |restaurant, action |
        restaurant.try(:manager) == user || restaurant.managers.include?(user)
      end

      can :manage, Discussion do |discussion,action|
        discussion && discussion.poster == user || discussion.users.include?(user)
      end

      can :manage, Admin::Conversation do |conversation,action|
        conversation.try(:recipient) == user
      end

      can :manage, AdminDiscussion do |discussion,action |
        discussion.restaurant && discussion.discussionable && discussion.discussionable.viewable_by?(
          discussion.restaurant.employments.find_by_employee_id(user.id)
        )
      end

      can :manage, MediaRequest do |message,action|
        message.sender == user
      end

      can :manage, MediaRequestDiscussion do |discussion,action |
        discussion.viewable_by?(discussion.restaurant.employments.find_by_employee_id(user.id))
      end

      can :manage, SoloMediaDiscussion do |discussion,action|
        discussion.employee == user
      end
    end
  end

end