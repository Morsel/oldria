require_relative '../../spec_helper'

describe Admin::SpecialtiesController do
  
  before(:each) do
    fake_admin_user
  end

  it "should create a new specialty" do
    post :create, :specialty => { :name => "Awesomesauce" }
    response.should be_redirect #_to('admin/specialties')
    Specialty.count.should == 1
  end
  
  it "should update a specialty" do
    Specialty.expects(:find).with("1").returns(specialty = FactoryGirl.create(:specialty))
    specialty.expects(:update_attributes).with("name" => "New Thing").returns(true)
    put :update, :id => 1, :specialty => { :name => "New Thing" }
    response.should be_redirect #_to('admin/specialties')
  end
  
  it "should delete a specialty" do
    Specialty.expects(:find).with("1").returns(specialty = FactoryGirl.create(:specialty))
    delete :destroy, :id => 1
    response.should be_redirect #_to('admin/specialties')
    Specialty.count.should == 0
  end

end
