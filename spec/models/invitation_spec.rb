# == Schema Information
#
# Table name: invitations
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  title              :string(255)
#  coworker           :boolean         default(FALSE)
#  restaurant_id      :integer
#  restaurant_name    :string(255)
#  requesting_user_id :integer
#  invitee_id         :integer
#  approved_at        :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  archived           :boolean         default(FALSE)
#

require 'spec_helper'

describe Invitation do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:invitation)
  end

  it "should create a new instance given valid attributes" do
    Invitation.create!(@valid_attributes)
  end
end
