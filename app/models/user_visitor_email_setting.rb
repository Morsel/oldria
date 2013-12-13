class UserVisitorEmailSetting < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter
  default_url_options[:host] = DEFAULT_HOST
  belongs_to :user
  after_save :update_email_at_column

  validates_presence_of :email_frequency 


  def update_email_at_column
    UserRestaurantVisitor.new.check_email_frequency(self) if ( next_email_at.blank? || last_email_at.blank? )
  end

end
