# == Schema Information
# Schema version: 20100928183146
#
# Table name: responsibilities
#
#  id                    :integer         not null, primary key
#  employment_id         :integer
#  subject_matter_id     :integer
#  created_at            :datetime
#  updated_at            :datetime
#  default_employment_id :integer
#

class Responsibility < ActiveRecord::Base
  belongs_to :subject_matter
  belongs_to :employment
  belongs_to :default_employment
end
