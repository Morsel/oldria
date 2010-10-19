require 'spec/spec_helper'

describe EmploymentsController do

  describe "POST reorder" do

    let(:restaurant) { Factory(:restaurant) }

    before(:each) do
      fake_admin_user
      @employment_a = Factory(:employment, :position => 1, :restaurant => restaurant)
      @employment_b = Factory(:employment, :position => 2, :restaurant => restaurant)
      @employment_c = Factory(:employment, :position => 3, :restaurant => restaurant)
    end

    it "should reorder based on ids" do
      post :reorder, :restaurant_id => restaurant.id,
          :employment => [@employment_b.id, @employment_c.id, @employment_a.id]
      restaurant.reload.employments.by_position.should == [@employment_b, @employment_c, @employment_a]
    end


  end

end