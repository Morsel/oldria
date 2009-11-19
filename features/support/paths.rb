module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /^the (?:homepage|dashboard)$/
      '/'
    when /^the coached status updates page$/
      admin_coached_status_updates_path
    when /^the signup page$/
      signup_path
    when /^the login page$/
      login_path
    when /^the password reset request page$/
      new_password_reset_path
    when /^the profile page for "(.+)"$/
      profile_path($1)
    when /^the statuses page for "(.+)"$/
      user_statuses_path(User.find_by_username($1))
    when /^the edit page for "(.+)"$/
      edit_user_path(User.find_by_username($1))

    # Media-users
    when /^the media( user)? signup page$/
      new_media_user_path
    when /^the media request search page$/
      new_media_request_path

    # Restaurants
    when /^the new restaurant page$/
      new_restaurant_path
    when /^the employees page for "(.+)"$/
      restaurant_employees_path(Restaurant.find_by_name($1))

    # Admin pages
    when /^the admin landing page$/
      admin_root_path
    when /^the admin users landing page$/
      admin_users_path
    when /^the list of account types$/
      admin_account_types_path
    when /^the list of media requests page$/
      admin_media_requests_path
    when /^the admin edit page for "(.+)"$/
      edit_admin_user_path(User.find_by_username($1))
    when /^the admin list static pages page$/
      admin_pages_path


    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "\nCan't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}\n"
    end
  end
end

World(NavigationHelpers)
