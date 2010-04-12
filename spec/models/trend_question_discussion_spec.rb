require 'spec/spec_helper'

describe TrendQuestionDiscussion do
  should_belong_to :restaurant
  should_belong_to :trend_question

  # should_validate_uniqueness_of :restaurant_id, :scope => :trend_question_id
end
