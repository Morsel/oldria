class UserVisitorEmailSetting < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST
  belongs_to :user
end

