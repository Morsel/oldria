require_relative '../spec_helper'

describe Users::BehindTheLineController do

  before(:each) do
    @user = Factory(:user)
    controller.stubs(:current_user).returns(@user)
  end

  describe "index" do

    it "should show you your topics" do
      role = Factory(:restaurant_role)
      @user.stubs(:primary_employment).returns(Factory(:employment, :restaurant_role => role, :employee => @user))

      question_role = Factory(:question_role, :restaurant_role => role)
      Factory(:profile_question, :question_roles => [question_role])

      get :index, :user_id => @user.id
      assigns[:topics].size.should == 1
    end

    it "should show you someone else's topics" do
      profile_user = Factory(:user)
      role = Factory(:restaurant_role)
      employment = Factory(:employment, :restaurant_role => role, :employee => profile_user)
      profile_user.stubs(:primary_employment).returns(employment)

      question_role = Factory(:question_role, :restaurant_role => role)
      question = Factory(:profile_question, :question_roles => [question_role])
      Factory(:profile_answer, :profile_question => question, :user => profile_user)

      get :index, :user_id => profile_user.id
      assigns[:topics].should == [question.topic]
    end

  end

end
