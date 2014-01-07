require_relative '../spec_helper'

describe MetropolitanAreasController do
  integrate_views

  before(:each) do
    @metropolitan_area = FactoryGirl.create(:metropolitan_area)
  end

  describe "GET index" do
    it "assigns all metropolitan_area as @metropolitan_area" do
      MetropolitanArea.stubs(:find).returns([@metropolitan_area])
      get :index, :format => 'js'
      @request.accept = "text/javascript"
      assigns[:metro_politan_area].should == [@metropolitan_area]
    end
  end

  it "assigns the requested metropolitan_area to @metropolitan_area" do
   metropolitan_area = FactoryGirl.build(:metropolitan_area)
   metro_politan_area_name = "test"
   get :auto_complete_metro_politan_areas,:metro_politan_area_name=>"test", :format => 'js'
   @request.accept = "text/javascript"
  end  
  
end

