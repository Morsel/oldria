require_relative '../spec_helper'

describe RestaurantAnswersController do

  before(:each) do
    @restaurant = Factory(:restaurant)
    @user = Factory.stub(:admin) # a restaurant manager would work, too, but takes more setup
    controller.stubs(:current_user).returns(@user)
  end

  it "should post a new answer" do
    question = Factory(:restaurant_question)
    RestaurantQuestion.stubs(:find).returns(question)
    answer = Factory(:restaurant_answer)
    question.expects(:find_or_build_answer_for).with(@restaurant).returns(answer)
    answer.expects(:save)

    post :create, :restaurant_question => { question.id => { :answer => "foo" }},
                  :restaurant_id => @restaurant.id,
                  :restaurant_question_id => question.id
  end

  it "should delete an answer" do
    answer = Factory(:restaurant_answer)
    RestaurantAnswer.stubs(:find).returns(answer)
    answer.expects(:destroy)

    delete :destroy, :restaurant_id => @restaurant.id, :id => answer.id
  end

end
