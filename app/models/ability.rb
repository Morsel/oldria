class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new #guests

    if user.admin?
      can :manage, :all
    else
      can :manage, Restaurant do |action, restaurant|
        restaurant && restaurant.manager == user || restaurant.additional_managers.include?(user)
      end

      can :manage, Discussion do |action, discussion|
        discussion && discussion.poster == user || discussion.users.include?(user)
      end
    end
  end

end