require_relative '../spec_helper'

describe Soapbox::MenuItemsController do

  it "should display menu items" do
    get :index
    assigns[:menu_items].should_not be_nil
  end

  it "should find and show a specific menu item" do
    menu_item = Factory(:menu_item)
    get :show, :id => menu_item.id
    assigns[:menu_item].should == menu_item
  end

end
