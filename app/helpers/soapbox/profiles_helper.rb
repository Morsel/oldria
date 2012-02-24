module Soapbox::ProfilesHelper

  def link_for_user_topics(opts = {})
    if soapbox?
      soapbox_user_questions_path(opts)
    else
      user_behind_the_line_path(opts[:id])
    end
  end

  def link_for_user_chapters(opts = {})
    if soapbox?
      soapbox_user_topic_path(opts)
    else
      user_btl_topic_path(opts)
    end
  end

  def link_for_user_questions(opts = {})
    if soapbox?
      soapbox_user_chapter_path(opts)
    else
      user_btl_chapter_path(opts)
    end
  end

  def path_for_profile(user)
    if logged_in_on_spoonfeed
      profile_path(user.username)
    elsif user.premium_account
      soapbox_profile_path(user.username)
    else
      # No url for non-premium accounts because we shouldn't see them off spoonfeed
      ""
    end
  end
end
