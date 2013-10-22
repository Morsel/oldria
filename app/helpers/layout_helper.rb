# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true, append = nil)
    @content_for_title = page_title.to_s
    @show_title = show_title
    @append = append
    content_for(:title) { page_title.to_s }
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end

  def active_link_to(text, path, options = {})
    selected = root_paths.include?(path) ? request.path == path : (request.path == path || request.path =~ /^#{path}/)
    css_class = selected ? ' selected' : ''
    options[:class] ||= ""
    options[:class] << css_class
    link_to text, path, options
  end
  
  private
  
  def root_paths
    [root_path, mediafeed_root_path, soapbox_root_path, hq_root_path, directory_path]
  end
  
end
