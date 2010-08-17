module UsersHelper
  
  def media_or_owner?
    return false unless current_user
    (current_user == @user) || current_user.media?
  end
  
  def media?
    return false unless current_user
    current_user.media?
  end
  
  def already_following?(follower)
    return true unless current_user
    (current_user == follower) || current_user.following?(follower)
  end
  
  def primary?(employment)
    employment == current_user.primary_employment
  end
end
