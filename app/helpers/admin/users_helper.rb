module Admin::UsersHelper

  def users_extra_row_class(user)
    admin_or_not = user.admin? ? 'admin' : ''
    media_or_not = user.media? ? 'media' : ''
    confirmed_or_unconfirmed = user.confirmed? ? 'confirmed' : 'unconfirmed'
    "#{admin_or_not} #{confirmed_or_unconfirmed}"
  end

end
