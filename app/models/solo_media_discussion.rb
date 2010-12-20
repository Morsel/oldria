# == Schema Information
# Schema version: 20101220214928
#
# Table name: solo_media_discussions
#
#  id               :integer         not null, primary key
#  media_request_id :integer
#  employment_id    :integer
#  comments_count   :integer         default(0)
#  created_at       :datetime
#  updated_at       :datetime
#

class SoloMediaDiscussion < ActiveRecord::Base

  acts_as_commentable
  belongs_to :media_request
  belongs_to :employment
  
  default_scope :order => "#{table_name}.created_at DESC"
  
  def viewable_by?(_employment)
    _employment == employment
  end
  
  def employee
    employment.employee
  end

end
