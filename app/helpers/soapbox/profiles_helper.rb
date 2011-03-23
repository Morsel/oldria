module Soapbox::ProfilesHelper

  def link_for_user_topics(opts = {})
    if soapbox?
      topics_soapbox_user_questions_path(opts)
    else
      topics_user_questions_path(opts)
    end
  end

  def link_for_user_chapters(opts = {})
    if soapbox?
      chapters_soapbox_user_questions_path(opts)
    else
      chapters_user_questions_path(opts)
    end
  end

end
