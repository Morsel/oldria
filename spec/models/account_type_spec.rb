# == Schema Information
#
# Table name: account_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec/spec_helper'

describe AccountType do
  it "should be valid" do
    AccountType.new.should be_valid
  end
end
