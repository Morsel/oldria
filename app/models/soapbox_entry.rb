# == Schema Information
# Schema version: 20100721223109
#
# Table name: soapbox_entries
#
#  id                 :integer         not null, primary key
#  published_at       :datetime
#  featured_item_id   :integer
#  featured_item_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class SoapboxEntry < ActiveRecord::Base
  belongs_to :featured_item, :polymorphic => true

  named_scope :qotd, :conditions => {:featured_item_type => 'Admin::Qotd'}
  named_scope :trend_question, :conditions => {:featured_item_type => 'TrendQuestion'}

  def title
    featured_item.title
  end

end
