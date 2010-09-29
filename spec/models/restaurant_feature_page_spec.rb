require 'spec/spec_helper'

describe RestaurantFeaturePage do

  describe "deletable" do

    let(:page) { RestaurantFeaturePage.create(:name => "Page") }

    specify { page.should be_deletable }

    it "should not be deletable if it has categories" do
      page.restaurant_feature_categories << RestaurantFeatureCategory.create(:name => "Cagetory")
      page.should_not be_deletable
    end

  end

end
# == Schema Information
#
# Table name: restaurant_feature_pages
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

