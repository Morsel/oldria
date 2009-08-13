class Status < ActiveRecord::Base
  belongs_to :user
  default_scope :order => "created_at DESC"
  include ActionView::Helpers

  before_validation :strip_html

  def strip_html
    self.message = strip_tags(message)
  end
end
