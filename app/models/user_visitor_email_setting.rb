class UserVisitorEmailSetting < ActiveRecord::Base
include ActionDispatch::Routing::UrlFor
include Rails.application.routes.url_helpers
default_url_options[:host] = DEFAULT_HOST
  belongs_to :user

 validates_presence_of :email_frequency 
 attr_accessible :email_frequency, :do_not_receive_email,:user_visitor_email_setting_attributes,:user_id,:next_email_at,:last_email_at
  
end


