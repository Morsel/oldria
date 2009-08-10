module StatusesHelper
  def owner?
    @user && @user == current_user
  end
end
