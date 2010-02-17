# == Schema Information
#
# Table name: responsibilities
#
#  id                :integer         not null, primary key
#  employment_id     :integer
#  subject_matter_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Responsibility < ActiveRecord::Base
  belongs_to :subject_matter
  belongs_to :employment
end
