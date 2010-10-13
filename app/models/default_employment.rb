# == Schema Information
# Schema version: 20101013222730
#
# Table name: employments
#
#  id                 :integer         not null, primary key
#  employee_id        :integer
#  restaurant_id      :integer
#  created_at         :datetime
#  updated_at         :datetime
#  restaurant_role_id :integer
#  omniscient         :boolean
#  primary            :boolean
#  type               :string(255)
#  public_profile     :boolean
#  position           :integer
#

class DefaultEmployment < Employment

  def restaurant
    nil
  end

end
