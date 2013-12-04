require_relative '../spec_helper'

describe Admin::TestimonialsController do

  before(:each) do
    @user = Factory(:admin)
    controller.stubs(:current_user).returns(@user)    
  end

  it "should list current testimonials" do
    get :index
    assigns[:testimonials].should_not be_nil
  end
  
  it "should let an admin create a new testimonials" do
    testimonial = Factory.build(:testimonial)
    Testimonial.expects(:new).returns(testimonial)
    testimonial.expects(:save).returns(true)
    post :create, :testimonial => { }
    response.should be_redirect
  end
  
  it "should let an admin update a testimonial" do
    testimonial = Factory(:testimonial)
    Testimonial.expects(:find).returns(testimonial)
    testimonial.expects(:update_attributes).returns(true)
    put :update, :id => testimonial.id, :soapbox_slide => { }
  end

end
