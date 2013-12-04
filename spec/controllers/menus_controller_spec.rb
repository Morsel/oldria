require_relative '../spec_helper'

describe MenusController do

  describe "POST reorder" do

    let(:restaurant) { Factory(:restaurant) }

    before(:each) do
      fake_admin_user
      @menu_a = Factory(:menu, :position => "1", :restaurant => restaurant)
      @menu_b = Factory(:menu, :position => "2", :restaurant => restaurant)
      @menu_c = Factory(:menu, :position => "3", :restaurant => restaurant)
    end

    it "should reorder based on ids" do
      post :reorder, :restaurant_id => restaurant.id,
          :menu => [@menu_b.id, @menu_c.id, @menu_a.id]
      restaurant.reload.menus.by_position.should == [@menu_b, @menu_c, @menu_a]
    end
  end
end