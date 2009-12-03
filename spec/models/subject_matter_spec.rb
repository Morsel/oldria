require 'spec/spec_helper'

describe SubjectMatter do
  should_have_many :responsibilities
  should_have_many :employments, :through => :responsibilities
  should_validate_presence_of :name
  should_have_default_scope :order => :name
end
