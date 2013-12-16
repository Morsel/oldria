require_relative '../../spec_helper'
include ActionDispatch::TestProcess
describe Soapbox::MenuItemsController do

  it "should display menu items" do
    get :index
    assigns[:menu_items].should_not be_nil
  end

  it "should find and show a specific menu item" do
  	@test_photo = ActionDispatch::Http::UploadedFile.new({
      :filename => 'index.jpeg',
      :type => 'image/jpeg',
      :tempfile => File.new("#{Rails.root}/spec/fixtures/index.jpeg")
    })
    menu_item = FactoryGirl.create(:menu_item,:photo=>@test_photo)
    get :show, :id => menu_item.id
    assigns[:menu_item].should == menu_item
  end

end
