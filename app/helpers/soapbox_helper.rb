module SoapboxHelper

  def resource_for_featured_item(soapbox_entry)
    return unless soapbox_entry.featured_item.present?
    if soapbox_entry.featured_item.class.to_s =~ /Admin::/
      url_for(:controller => 'admin/messages', :action => 'show', :id => soapbox_entry.featured_item.id)
    else
      [:admin, soapbox_entry.featured_item]
    end
  end

  def soapbox_tabby_title(featured_item)
    if featured_item.is_a?(TrendQuestion)
      "<h1 class='trend'>#{link_to 'What\'s New', soapbox_soapbox_entry_path(featured_item.soapbox_entry)}</h1>".html_safe
    elsif featured_item.is_a?(Admin::Qotd)
      "<h1 class='qotd'>#{link_to 'Question of the Day', soapbox_soapbox_entry_path(featured_item.soapbox_entry)}</h1>".html_safe
    end
  end

  def entry_for_comment(comment)
    if comment.commentable.is_a?(Admin::Conversation)
      comment.commentable.admin_message.soapbox_entry
    elsif comment.commentable.is_a?(AdminDiscussion)
      comment.commentable.discussionable.soapbox_entry
    elsif comment.commentable.is_a?(SoloDiscussion)
      comment.commentable.trend_question.soapbox_entry
    end
  end
  
  def message(featured_item)
    featured_item.display_message.present? ? featured_item.display_message : featured_item.message
  end

  def soapbox_title(featured_item)    
    "#{message(featured_item)} - Soapbox " + 
    if featured_item.is_a?(TrendQuestion)
      "Trend"
    elsif featured_item.is_a?(Admin::Qotd)
      "Question of the Day"
    end
  end
  
  def active_page?(name)
    current_page?(name) ? "selected" : ""
  end

  def feature_entry_type(feature)
    feature.is_a?(TrendQuestion) ? "trend_entry" : "qotd_entry"
  end
  
  def link_if_soapbox(question)
    if on_soapbox
      link_to question.question, soapbox_a_la_minute_question_path(question)
    else
      question.question
    end
  end

  def alm_links
    ALaMinuteQuestion.answered.all(:order => "topic, question").uniq
  end

  def newsfeed_links
    PromotionType.used_by_current_promotions.from_premium_restaurants.all(:order => :name).uniq
  end

  def btl_links
    Topic.user_topics.without_travel.all(:order => "title")
  end

  def travel_links
    Topic.travel.chapters.answered_by_premium_users.all(:limit => 15) if Topic.travel
  end

  def load_homepage_feeds
    @alm_questions = ALaMinuteQuestion.most_recent_for_soapbox(4)
    @promotions = Promotion.from_premium_restaurants.recently_posted.all(:limit => 4)
    @btl_answers = ProfileAnswer.without_travel.from_premium_users.from_public_users.recently_answered.all(:limit => 5)
    @menu_items = MenuItem.from_premium_restaurants.all(:limit => 4, :order => "created_at DESC")
  end

  def recent_newsfeed
    Promotion.from_premium_restaurants.current
  end

end
