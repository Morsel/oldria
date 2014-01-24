require_relative '../../spec_helper'

describe Soapbox::ALaMinuteAnswersController do
  integrate_views
  
    describe "GET show" do
      it "GET show" do
        @a_la_minute_answer = FactoryGirl.create(:a_la_minute_answer)
        get :show ,:id => @a_la_minute_answer.id
        @restaurant = @a_la_minute_answer.restaurant.id
        @question = @a_la_minute_answer.a_la_minute_question
        @sidebar_questions = ALaMinuteQuestion.all(:order => "question")        
        @promotions = @a_la_minute_answer.restaurant.promotions.all(:conditions=>["DATE(start_date) >=  DATE(?)", Time.now],:order => "created_at DESC",:limit=>3)
        @menu_items = @a_la_minute_answer.restaurant.menu_items.all(:limit=>3,:order=>"menu_items.created_at DESC")
        @answers =  @a_la_minute_answer.restaurant.a_la_minute_answers.all(:limit=>3,:order => "a_la_minute_answers.created_at DESC",:conditions=>["DATE(a_la_minute_answers.created_at) = DATE(?) and a_la_minute_answers.id <> ?", Time.now,@a_la_minute_answer.id])
        assigns[:restaurant].should == @restaurant
        assigns[:question].should == @question
        assigns[:sidebar_questions].should == @sidebar_questions
        assigns[:promotions].should == @promotions
        assigns[:menu_items].should == @menu_items
        assigns[:answers].should == @answers
        response.should render_template('show')
      end
    end 
end

