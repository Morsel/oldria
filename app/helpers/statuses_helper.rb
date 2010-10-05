module StatusesHelper
  def owner?
    @user && @user == current_user
  end
  
  def facebook_page_name(status)
    status.user.facebook_page.fetch
    status.user.facebook_page.name
  rescue
    "Currently unavailable"
  end
end
