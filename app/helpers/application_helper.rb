# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def button_tag(content = "Submit", options = {}, escape = true, &block)
    options.reverse_merge!(:type => 'submit')
    content_tag(:button, content, options, escape, &block)
  end

  def date_for(date)
    if date < 1.day.ago
      date.strftime('%b %d, %Y')
    else
      time_ago_in_words(date) + ' ago'
    end
  end

  def fb_login_link(url=root_path)
    link_to_function image_tag("connect.gif"),
        "FB.login(function() {	window.location.href='#{url}'},{perms: 'offline_access,publish_stream,email,friends_status,manage_pages'});",
        :class => "facebook_login"
  end


  def display_sidebar?
    controller_name != "soapbox"
  end

  def div_if(boolean, options={}, &block)
    return "" unless boolean
    content = content_tag(:div, options, &block)
    concat(content)
    content
  end

  def delete_link_for(deletable_object, path)
    return "" unless deletable_object.deletable?
    link_to "[x]", path, :method => :delete,
        :confirm => "Are you sure you want to permanently delete #{deletable_object.name}?",
        :class => "delete_link", :id => dom_id(deletable_object, :delete_link)
  end

end
