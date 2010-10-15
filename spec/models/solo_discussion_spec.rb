# == Schema Information
#
# Table name: solo_discussions
#
#  id                :integer         not null, primary key
#  employment_id     :integer
#  trend_question_id :integer
#  comments_count    :integer         default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe SoloDiscussion do

end
