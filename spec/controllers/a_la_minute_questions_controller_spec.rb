require 'spec_helper'

describe ALaMinuteQuestionsController do

  describe "#show_as_public" do

    let(:restaurant) { Factory(:restaurant) }
    let(:question) { Factory(:a_la_minute_question) }

    before(:each) do
      4.times do |i|
        Factory(:a_la_minute_answer, :responder => restaurant, :a_la_minute_question => question,
            :answer => "Answer #{i}")
      end
    end

    context "when answers are private" do
      before(:each) do
        ALaMinuteAnswer.all.each { |answer| answer.update_attributes(:show_as_public => false) }
      end

      it "should set show_as_public to true on all its answers" do
        post :show_as_public, :restaurant_id => restaurant.id, :id => question.id, :a_la_minute_question => {:show_as_public => true}
        ALaMinuteAnswer.all.each { |answer| answer.show_as_public.should be_true }
      end
    end

    context "when answers are public" do
      before(:each) do
        ALaMinuteAnswer.all.each { |answer| answer.update_attributes(:show_as_public => true) }
      end

      it "should set show_as_public to false on all its answers" do
        post :show_as_public, :restaurant_id => restaurant.id, :id => question.id, :a_la_minute_answer => {:show_as_public => false}
        ALaMinuteAnswer.all.each { |answer| answer.show_as_public.should be_false }
      end
    end

    context "when request is html" do
      it "should redirect to restaurant path" do
        post :show_as_public, :restaurant_id => restaurant.id, :id => question.id, :a_la_minute_answer => {:show_as_public => false}

        response.should redirect_to(restaurant_url(restaurant))
      end
    end

    context "when request is xhr" do
      it "should set show_as_public to true on all its answers" do
        xhr :post, :show_as_public, :restaurant_id => restaurant.id, :id => question.id, :a_la_minute_answer => {:show_as_public => true}

        response.body.should be_blank
      end
    end
  end
end