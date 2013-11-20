module MediaRequestsHelper
  def sent_date_and_recipient_count(media_request)
    count = media_request.media_request_discussions.size
    "You sent this #{time_ago_in_words(media_request.created_at)} ago to  #{pluralize(count, 'person')}"
  end

  def response_count(media_request)
    count = media_request.reply_count
    if count == 0
      "No one has responded"
    elsif count == 1
      "1 person has responded"
    else
      "#{count} people have responded"
    end
  end

  def formatted_fields(media_request, options={})
    before_key = options[:before_key] || '<span class="fieldname">'
    after_key = options[:after_key] || "</span>"
    html_tag = options[:html_tag] || "p"
    outer_tag = options[:html_tag] || "div"

    stringified = media_request.fields.inject("") do |result, (key,value)|
      result += content_tag(html_tag, "#{before_key.html_safe + key.to_s.humanize + after_key.html_safe + value}\n".html_safe)
    end

    # content_tag(outer_tag, :class => "fields") { stringified }
  end

  def last_comment_and_date_span(comment)
     "#{comment.user.name} said, &ldquo;#{comment.comment}&rdquo;"+
     "<span class=\"commentdate\">" +
     time_ago_in_words(comment.created_at) +
     " ago</span> "
    
  end

  def multiple_checkbox_search(collection, search_method)
    content_tag :ul, :class => 'multiple_checkbox' do
      collection.inject("") do |result, obj|
        result + "<li><label>" +
        check_box_tag("search[#{search_method}][]", obj.id, false) +
        obj.name + "</label></li>"
      end
    end
  end

end
