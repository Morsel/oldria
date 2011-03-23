# == Schema Information
# Schema version: 20110323195248
#
# Table name: employments
#
#  id                   :integer         not null, primary key
#  employee_id          :integer
#  restaurant_id        :integer
#  created_at           :datetime
#  updated_at           :datetime
#  restaurant_role_id   :integer
#  omniscient           :boolean
#  primary              :boolean
#  type                 :string(255)
#  public_profile       :boolean         default(TRUE)
#  position             :integer
#  post_to_soapbox      :boolean         default(TRUE)
#  solo_restaurant_name :string(255)
#

class DefaultEmployment < Employment
  
  has_many :solo_discussions, :foreign_key => "employment_id", :dependent => :destroy
  has_many :solo_media_discussions, :foreign_key => "employment_id", :dependent => :destroy

  def restaurant
    nil
  end
  
  def viewable_media_request_discussions
    solo_media_discussions.approved
  end

  def viewable_unread_media_request_discussions
    solo_media_discussions.approved.select { |d| !d.read_by?(self.employee) }
  end

end
