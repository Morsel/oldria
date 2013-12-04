require_relative '../spec_helper'

describe Admin::SpecialtiesController do
  
  before(:each) do
    fake_admin_user
  end

  it "should create a new specialty" do
    post :create, :specialty => { :name => "Awesomesauce" }
    response.should redirect_to('admin/specialties')
    Specialty.count.should == 1
  end
  
  it "should update a specialty" do
    Specialty.expects(:find).with("1").returns(specialty = Factory(:specialty))
    specialty.expects(:update_attributes).with("name" => "New Thing").returns(true)
    put :update, :id => 1, :specialty => { :name => "New Thing" }
    response.should redirect_to('admin/specialties')
  end
  
  it "should delete a specialty" do
    Specialty.expects(:find).with("1").returns(specialty = Factory(:specialty))
    delete :destroy, :id => 1
    response.should redirect_to('admin/specialties')
    Specialty.count.should == 0
  end

end
