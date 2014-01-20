require_relative '../../spec_helper'

describe Admin::Qotd do
  it { should have_one(:soapbox_entry).with_foreign_key('featured_item_id').dependent(:destroy) }
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:admin_message, :type => 'Admin::Qotd')
  end

  it "should set a class-based title of 'Question of the Day'" do
    Admin::Qotd.title.should == "Question of the Day"
  end

  it "should set a class-based short title of 'QOTD'" do
    Admin::Qotd.shorttitle.should == "QOTD"
  end

  it "should create a new instance given valid attributes" do
    Admin::Qotd.create!(@valid_attributes)
  end

  describe ".current" do
    it "should return .current" do
      admin_message = FactoryGirl.create(:admin_message)
      Admin::Qotd.current.should == Admin::Qotd.find(:all,:conditions=>['scheduled_at < ? OR scheduled_at IS NULL', Time.zone.now])
    end
  end 

  describe ".title" do
    it "should return .title" do
      admin_message = FactoryGirl.create(:admin_message)
      Admin::Qotd.title.should == "Question of the Day"
    end
  end   

  describe ".shorttitle" do
    it "should return .shorttitle" do
      admin_message = FactoryGirl.create(:admin_message)
      Admin::Qotd.shorttitle.should == "QOTD"
    end
  end   

  describe "#title" do
    it "should return .title" do
      admin_message = FactoryGirl.create(:admin_message)
      Admin::Qotd.title.should == "Question of the Day"
    end
  end 

  describe ".recipients_can_reply?" do
    it "should return .recipients_can_reply?" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.recipients_can_reply?.should == true
    end
  end   

  describe "#mailer_method" do
    it "should return #mailer_method" do
      admin_message = FactoryGirl.create(:admin_message)
      admin_message.mailer_method.should == 'message_notification'
    end
  end   

end


