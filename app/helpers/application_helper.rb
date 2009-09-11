# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def button_tag(content = "Submit", options = {}, escape = true, &block)
    options.reverse_merge!(:type => 'submit')
    content_tag(:button, content, options, escape, &block) 
  end
end
