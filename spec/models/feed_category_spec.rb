require_relative '../spec_helper'

describe FeedCategory do
  it { should have_many(:feeds).order(:position) }
end
