require_relative '../spec_helper'

describe RestaurantAnswersController do

  before(:each) do
    @restaurant = FactoryGirl.create(:restaurant)
    @user = FactoryGirl.create(:admin) # a restaurant manager would work, too, but takes more setup
    controller.stubs(:current_user).returns(@user)
  end

  it "should post a new answer" do
    question = FactoryGirl.create(:restaurant_question)
    RestaurantQuestion.stubs(:find).returns(question)
    answer = FactoryGirl.create(:restaurant_answer)
    question.find_or_build_answer_for(@restaurant) == answer 
    answer.save

    post :create, :restaurant_question => { question.id => { :answer => "foo" }},
                  :restaurant_id => @restaurant.id,
                  :restaurant_question_id => question.id
  end

  it "should delete an answer" do
    answer = FactoryGirl.create(:restaurant_answer)
    RestaurantAnswer.stubs(:find).returns(answer)
    # answer.expects(:destroy)

    delete :destroy, :restaurant_id => @restaurant.id, :id => answer.id
  end

  it "show action should render show template" do
    get :show
    response.should render_template(:show)
  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        question = FactoryGirl.create(:restaurant_question)
        RestaurantQuestion.stubs(:find).returns(question)
        @answer = FactoryGirl.create(:restaurant_answer)
        RestaurantAnswer.stubs(:find).returns(@answer)
        RestaurantAnswer.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested answer" do
        RestaurantAnswer.expects(:find).with("37").returns(@answer)
        put :update, :id => "37", :answer => {:these => 'params'}, :restaurant_id => @restaurant.id
      end

      it "assigns the requested answer as @answer" do
        RestaurantAnswer.stubs(:find).returns(@answer)
        put :update, :id => "1", :restaurant_id => @restaurant.id
        assigns[:answer].should equal(@answer)
      end

      it "redirects to all answer" do
        RestaurantAnswer.stubs(:find).returns(@answer)
        put :update, :id => "1", :restaurant_id => @restaurant.id
        response.should redirect_to restaurant_social_posts_path(@restaurant)
      end
    end
  end 

end
