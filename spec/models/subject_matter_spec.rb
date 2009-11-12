require File.dirname(__FILE__) + '/../spec_helper'

describe SubjectMatter do
  should_validate_presence_of :name
  should_have_many :responsibilities
  should_have_many :employments, :through => :responsibilities
end
