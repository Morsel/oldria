require_relative '../spec_helper'

describe Invitation do
  it { should belong_to(:requesting_user).class_name('User') }
  it { should belong_to(:invitee).class_name('User') }
  it { should belong_to(:restaurant) }
  it { should belong_to(:restaurant_role) }
  it { should have_many(:invite_responsibilities).dependent(:destroy) }
  it { should have_many(:subject_matters).through(:invite_responsibilities) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:restaurant_role) }
  it { should validate_presence_of(:restaurant_name) }
  it { should validate_presence_of(:subject_matters) }
  it { should validate_uniqueness_of(:email).
      with_message('That email address has already been invited') }
  it { should_not allow_value('/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i').for(:email).
      with_message('is not a valid email address') }


  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:invitation)
    @valid_attributes[:restaurant_role] = FactoryGirl.create(:restaurant_role)
  end

  it "should create a new instance given valid attributes" do
    Invitation.create!(@valid_attributes)
  end
  
  describe "admin_invitation_notice and invitation_welcome" do
    let(:invitation){ FactoryGirl.create(:invitation) }
    
    it "should send admins an email after creation" do
      mail = UserMailer.admin_invitation_notice(invitation)
      mail.subject.should == "A new invitation has been requested"
      mail = UserMailer.invitation_welcome(invitation)
      mail.subject.should == "Spoonfeed Invitation Request Received"
      #UserMailer.expects(:invitation_welcome).returns(true)
      # Invitation.create!(@valid_attributes)
    end    
  end

  describe "#name" do
    it "should return the name" do
      invitation = FactoryGirl.create(:invitation)
      invitation.name.should == "Jane Doe"
    end 
  end

  describe "#username" do
    it "should return the name" do
      invitation = FactoryGirl.create(:invitation)
      invitation.username.should == "janedoe"
    end 
  end


end

