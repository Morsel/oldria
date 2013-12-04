require_relative '../spec_helper'

describe Responsibility do
  should_belong_to :subject_matter
  should_belong_to :employment
end
