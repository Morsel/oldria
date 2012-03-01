module Soapbox::ProfilesHelper

  def link_for_user_topics(opts = {})
    if soapbox?
      soapbox_user_profile_questions_path(opts)
    else
      user_behind_the_line_path(opts[:id])
    end
  end

  def link_for_user_chapters(opts = {})
    if soapbox?
      soapbox_user_btl_topic_path(opts)
    else
      user_btl_topic_path(opts)
    end
  end

end
