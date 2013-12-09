require_relative '../spec_helper'

describe JamesBeardRegion do
  it { should have_many :restaurants }
  it { should have_many :users }
  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
end
