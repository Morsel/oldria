# uncomment to use jQuery.noConflict()
#ActionView::Helpers::PrototypeHelper::JQUERY_VAR = 'jQuery'

ActionView::Helpers::AssetTagHelper::JAVASCRIPT_DEFAULT_SOURCES = [
  'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js',
  'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/jquery-ui.min.js',
  'jrails']
ActionView::Helpers::AssetTagHelper::reset_javascript_include_default
require 'jrails'
