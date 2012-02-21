# == Schema Information
# Schema version: 20120217190417
#
# Table name: responsibilities
#
#  id                :integer         not null, primary key
#  employment_id     :integer
#  subject_matter_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_responsibilities_on_subject_matter_id  (subject_matter_id)
#  index_responsibilities_on_employment_id      (employment_id)
#

class Responsibility < ActiveRecord::Base
  belongs_to :subject_matter
  belongs_to :employment
end
