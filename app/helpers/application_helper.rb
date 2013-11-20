# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  include SubscriptionsControllerHelper

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
        "FB.login(function() {window.location.href = '#{url}'}, {scope: 'user_status,offline_access, publish_stream, email, friends_status, manage_pages,user_photos,friends_photos'});", :class => "facebook_login"
  end

  def div_if(boolean, options={}, &block)
    return "" unless boolean
    content_tag(:div, options, &block)
  end

  def dl_if(boolean, options={}, &block)
    return "" unless boolean
    content_tag(:dl, options, &block)
  end

  def delete_link_for(deletable_object, path)
    return "" unless deletable_object.deletable?
    link_to "[x]", path, :method => :delete,
        :confirm => "Are you sure you want to permanently delete #{deletable_object.name}?",
        :class => "delete_link", :id => dom_id(deletable_object, :delete_link)
  end

  def on_soapbox
    soapbox?
  end

  def not_soapbox
    !on_soapbox
  end

  def on_mediafeed
    mediafeed?
  end

  def not_mediafeed
    !on_mediafeed
  end

  def logged_in_and_not_soapbox
    not_soapbox && current_user
  end

  def logged_in_on_spoonfeed
    current_user.present? && not_soapbox && !current_user.media?
  end

  def logged_in_on_spoonfeed_for_media
    current_user.present? && not_soapbox && current_user.media?
  end


  def media_user_prefers_publish_profile?
    current_user.present? && current_user.media?
  end

  def logo_for(obj)
    obj.logo || Image.new
  end

  def restaurant_feature_page_link(restaurant, page)
    if on_soapbox
      soapbox_restaurant_feature_page_path(restaurant, page)
    else
      restaurant_feature_page_path(restaurant, page)
    end
  end
  
  def btl_profile_link(commenter)
    if commenter.is_a?(User)
      profile_path(commenter.username)
    elsif commenter.is_a?(Restaurant)
      restaurant_path(commenter)
    end
  end

  def link_to_unimplemented(string, opts = {})
    link_to_function(string, "alert('Not implemented yet')", opts)
  end

  def remove_special_char string
    string.gsub(/[^0-9A-Za-z]/, ' ')
  end
end
