require_relative '../spec_helper'

describe Menu do
  before(:each) do
    @restaurant = FactoryGirl.create(:restaurant)
    pdf_remote_attachment = PdfRemoteAttachment.create!(:attachment_content_type => "application/pdf", :attachment_file_name => "my_file.pdf")
    @valid_attributes = {
      :name => "value for name",
      :change_frequency => "Monthly",
      :pdf_remote_attachment => pdf_remote_attachment,
      :restaurant_id => @restaurant.id
    }
  end

  it "should create a new instance given valid attributes" do
    Menu.create!(@valid_attributes)
  end

  it "should create a new site activity message when saved" do
    Menu.create!(@valid_attributes)
    SiteActivity.last.description.should == "Saved menu"
  end

  describe "validations" do
    describe "change_frequency" do
      it "fails if change_frequency is not one of the allowed values" do
        attributes = @valid_attributes.merge(:change_frequency => "Once a Decade")
        menu = Menu.new(attributes)
        result = menu.save
        result.should be_false
      end
    end
  end

  # describe "default scope" do
  #   it "should sort by position" do
  #     menu_a = Menu.create!(@valid_attributes.merge({:name => "menu_a", :position => 2}))
  #     menu_b = Menu.create!(@valid_attributes.merge({:name => "menu_b", :position => 0}))
  #     menu_c = Menu.create!(@valid_attributes.merge({:name => "menu_c", :position => 1}))
  # 
  #     Menu.all.should == [menu_b, menu_c, menu_a]
  #   end
  # end

  describe "by_position scope" do
    it "should sort by position" do
      menu_a = Menu.create!(@valid_attributes.merge({:name => "menu_a", :position => 2}))
      menu_b = Menu.create!(@valid_attributes.merge({:name => "menu_b", :position => 0}))
      menu_c = Menu.create!(@valid_attributes.merge({:name => "menu_c", :position => 1}))

      Menu.by_position.should == [menu_b, menu_c, menu_a]
    end
  end
end


