require_relative '../../spec_helper'

describe Users::BehindTheLineController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(@user)
  end

  describe "index" do

    it "should show you your topics" do
      role = FactoryGirl.create(:restaurant_role)
      @user.stubs(:primary_employment).returns(FactoryGirl.create(:employment, :restaurant_role => role, :employee => @user))

      question_role = FactoryGirl.create(:question_role, :restaurant_role => role)
      FactoryGirl.create(:profile_question, :question_roles => [question_role])

      get :index, :user_id => @user.id
      assigns[:topics].size.should == 1
    end

    it "should show you someone else's topics" do
      profile_user = FactoryGirl.create(:user)
      role = FactoryGirl.create(:restaurant_role)
      employment = FactoryGirl.create(:employment, :restaurant_role => role, :employee => profile_user)
      profile_user.stubs(:primary_employment).returns(employment)

      question_role = FactoryGirl.create(:question_role, :restaurant_role => role)
      question = FactoryGirl.create(:profile_question, :question_roles => [question_role])
      FactoryGirl.create(:profile_answer, :profile_question => question, :user => profile_user)

      get :index, :user_id => profile_user.id
      assigns[:topics].should == [question.topic]
    end

  end

  it "Work for chapter" do
    profile_user = FactoryGirl.create(:user)
    role = FactoryGirl.create(:restaurant_role)
    employment = FactoryGirl.create(:employment, :restaurant_role => role, :employee => profile_user)
    profile_user.stubs(:primary_employment).returns(employment)
    question_role = FactoryGirl.create(:question_role, :restaurant_role => role)
    question = FactoryGirl.create(:profile_question, :question_roles => [question_role])
    FactoryGirl.create(:profile_answer, :profile_question => question, :user => profile_user)
    get :chapter,:id=>chapter.id, :user_id => profile_user.id
    response.should render_template(:new)
  end



end
