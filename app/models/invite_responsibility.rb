# == Schema Information
# Schema version: 20120217190417
#
# Table name: invite_responsibilities
#
#  id                :integer         not null, primary key
#  invitation_id     :integer
#  subject_matter_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class InviteResponsibility < ActiveRecord::Base
  
  belongs_to :invitation
  belongs_to :subject_matter
  attr_accessible :invitation_id, :subject_matter_id
end
