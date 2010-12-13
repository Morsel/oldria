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
      "<h1>#{link_to 'Trend Identified', soapbox_soapbox_entry_path(featured_item.soapbox_entry)}</h1>"
    elsif featured_item.is_a?(Admin::Qotd)
      "<h1 class='qotd'>#{link_to 'Question of the Day', soapbox_soapbox_entry_path(featured_item.soapbox_entry)}</h1>"
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

end
