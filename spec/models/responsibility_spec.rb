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

require 'spec/spec_helper'

describe Responsibility do
  should_belong_to :subject_matter
  should_belong_to :employment
end
