module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /^the (?:homepage|dashboard)$/
      '/'
    when /the new a_la_minute page/
      new_a_la_minute_path
    when /the cancel subscription page for "(.+)"/
      subscription_path(:id => User.find_by_username($1).id)
    when /the new subscription page for the restaurant "(.+)"/
      new_restaurant_subscription_path(Restaurant.find_by_name($1))
    when /the new subscription page for "(.+)"/
      new_user_subscription_path(User.find_by_username($1))

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
    when /^(my )?feeds page$/
      feeds_path
    when /^the (edit|choose) (my )?feeds page$/
      edit_feeds_path
    when /^(my|the)? ?inbox$/
      messages_path
    when /^the new conversations page$/
      new_conversation_path
    when "my profile's edit page"
      edit_my_profile_path
    when "the new invitation page"
      new_invitation_path
    when "the new invitation recommendation page"
      recommend_invitations_path
    when "Front Burner"
      front_burner_path

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
    when "the RIA messages page"
      ria_messages_path
    when /^the new event page for "(.+)"$/
      new_restaurant_event_path(:restaurant_id => Restaurant.find_by_name($1).id)
    when /the calendars page for "(.+)"$/
      restaurant_calendars_path(:restaurant_id => Restaurant.find_by_name($1).id)
    when /the edit restaurant page for "(.+)"$/
      edit_restaurant_path(Restaurant.find_by_name($1))
    when /the restaurant show page for "(.+)"$/
      restaurant_path(Restaurant.find_by_name($1))
    when /the restaurant feature page for "(.+)"/
      restaurant_features_path(Restaurant.find_by_name($1))
    when /^the restaurant menu upload page for (.+)$/
      bulk_edit_restaurant_menus_path(Restaurant.find_by_name($1))
    when /^the employee edit page for "(.+)" and "(.+)"$/
      edit_restaurant_employee_path(Restaurant.find_by_name($1), User.find_by_username($2))


    # Media Requests
    when /^the media request discussion page$/
      media_request_discussion_path(MediaRequestDiscussion.last)

    # Admin pages
    when /^the admin landing page$/
      admin_root_path
    when /^the admin users landing page$/
      admin_users_path
    when /^the admin restaurants page$/
      admin_restaurants_path
    when /^the admin feeds page$/
      admin_feeds_path
    when /^the list of media requests page$/
      admin_media_requests_path
    when /^the admin edit page for "(.+)"$/
      edit_admin_user_path(User.find_by_username($1))
    when /^the admin edit restaurant page for (.+)$/
      edit_admin_restaurant_path(Restaurant.find_by_name($1))
    when /^the admin list static pages page$/
      admin_pages_path
    when /^the admin new user page$/
      new_admin_user_path
    when /^the new QOTD page$/
      new_admin_qotd_path
    when /^the new Announcement page$/
      new_admin_announcement_path
    when /^the new holiday page/
      new_admin_holiday_path
    when /^the new trend question page/
      new_admin_trend_question_path
    when /^the list of trend questions$/
      admin_trend_questions_path
    when /^the new PR Tip page$/
      new_admin_pr_tip_path
    when /^the admin calendars page$/
      admin_calendars_path
    when /^the new admin event page$/
      new_admin_event_path
    when /^the new (.+) profile question page$/
      new_admin_profile_question_path(:responder_type => $1.downcase)
    when /^the admin (.+) profile questions page$/
      admin_profile_questions_path(:responder_type => $1.downcase)
    when /^the chapters page$/
      admin_chapters_path
    when /^the new (.+) topic page$/
      new_admin_topic_path(:responder_type => $1.downcase)
    when /^the (.+) topics page$/
      admin_topics_path(:responder_type => $1.downcase)
    when /^the (.+) chapters page$/
      admin_chapters_path(:responder_type => $1.downcase)
    when /^the admin invitations page$/
      admin_invitations_path
    when /^the restaurant photo upload page for (.+)$/
      bulk_edit_restaurant_photos_path(Restaurant.find_by_name($1))
    when /^the admin restaurant feature page$/
      admin_restaurant_features_path
    when /^the admin a la minute questions page$/
      admin_a_la_minute_questions_path
    when /^the edit a la minute question page for "(.+)"$/
      bulk_edit_restaurant_a_la_minute_answers_path(:restaurant_id => Restaurant.find_by_name($1).id)

    # Soapbox
    when /the soapbox index page/
      soapbox_root_path
    when /the soapbox front burner page/
      soapbox_soapbox_entries_path
    when /the soapbox profile page for "(.+)"/
      soapbox_profile_path($1)
    when /the soapbox restaurant profile for "(.+)"/
      soapbox_restaurant_path(Restaurant.find_by_name($1))
    when /the soapbox feature page for "(.+)"/
      soapbox_restaurant_feature_page_path(RestaurantFeature.find_by_value($1))
    when /the soapbox restaurant feature page for "(.+)" and "(.+)"/
      soapbox_restaurant_feature_page_path(
          Restaurant.find_by_name($1), RestaurantFeaturePage.find_by_name($2))

    # Question
    when /^the question page with title "(.+)"$/
      question_path(ProfileQuestion.find_by_title($1).id)

    # Direct path
    when /"([^\"]+)"/
      $1

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
