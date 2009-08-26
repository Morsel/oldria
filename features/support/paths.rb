module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the homepage/
      '/'
    when /^the coached status updates page$/
      coached_status_updates_path
    when /^the signup page$/
      signup_path
    when /^the login page$/
      login_path
    when /^the password reset request page$/
      new_password_reset_path

    when /^the statuses page for "(.+)"$/
      user_statuses_path(User.find_by_username($1))

    # Admin pages
    when /^the admin landing page$/
      admin_root_path
    when /^the list of account types$/
      admin_account_types_path

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
