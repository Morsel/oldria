require_relative '../spec_helper'

describe Cookbook do
  it { should belong_to(:profile) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:publisher) }
  it { should validate_presence_of(:published_on) }
     
end

