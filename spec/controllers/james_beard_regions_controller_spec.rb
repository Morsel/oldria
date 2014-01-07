require_relative '../spec_helper'

describe JamesBeardRegionsController do
  integrate_views

  before(:each) do
    @james_beard_region = FactoryGirl.create(:james_beard_region)
  end

  describe "GET index" do
    it "assigns all james_beard_regions as @james_beard_regions" do
      JamesBeardRegion.stubs(:find).returns([@james_beard_region])
      get :index, :format => 'js'
      @request.accept = "text/javascript"
      assigns[:james_beard_region].should == [@james_beard_region]
    end
  end

  it "assigns the requested james_beard_region to @james_beard_region" do
   james_beard_region = FactoryGirl.build(:james_beard_region)
   region_name = "test"
   get :auto_complete_james_beard_regions,:region_name=>"test", :format => 'js'
   @request.accept = "text/javascript"
  end  
  
end

