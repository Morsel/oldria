require 'spec_helper'

describe TraceKeywordsController do

	before(:each) do
    @user = current_user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns current_user
  end

  # it "should create a new keyword" do
  # 	if @user.media?
  #     trace_keyword = FactoryGirl.create(:trace_keyword)
  #     expect(trace_keyword.keywordable_id).to be_true
  #     expect(trace_keyword.keywordable_type).to be_true
  #     expect(trace_keyword.user_id).to be_true
  #     trace_keyword.increment!(:count)  
  #   end 

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new tracekeyword" do
       lambda do
        expect{
          post :create, TraceKeyword: FactoryGirl.attributes_for(:trace_keyword) 
        }.to change(TraceKeyword,:count).by(1)
       end  
      end  
      it "redirects to TraceKeyword path" do
        post :create, trace_keyword: FactoryGirl.attributes_for(:trace_keyword) 
        @request.accept = "text/javascript"
      end
    end 
    context "with invalid attributes" do
      it "does not save the new TraceKeyword" do
        expect{
          post :create, TraceKeyword: FactoryGirl.attributes_for(:invalid_trace_keyword) 
         }.to_not change(TraceKeyword,:count)
      end
      it "re-renders the new method" do
         post :create, trace_keyword: FactoryGirl.attributes_for(:invalid_trace_keyword) 
         @request.accept = "text/javascript"
      end 
    end  
  end 

  describe "POST soapbox trace" do
  	context "with valid attributes" do
      it "creates a new soapbox trace" do
       lambda do
        expect{
          post :create, SoapboxTraceKeyword: FactoryGirl.attributes_for(:soapbox_trace_keyword) 
        }.to change(SoapboxTraceKeyword,:count).by(1)
       end  
      end  
      it "redirects to TraceKeyword path" do
        post :create, trace_keyword: FactoryGirl.attributes_for(:soapbox_trace_keyword) 
        @request.accept = "text/javascript"
      end
    end 
    context "with invalid attributes" do
      it "does not save the new soapbox trace" do
        lambda do
          expect{
            post :create, SoapboxTraceKeyword: FactoryGirl.attributes_for(:invalid_soapbox_trace_keyword) 
          }.to change(SoapboxTraceKeyword,:count).by(1)
        end
       end  
      it "re-renders the new method" do
        post :create, soapbox_trace_keyword: FactoryGirl.attributes_for(:invalid_soapbox_trace_keyword) 
        @request.accept = "text/javascript"
      end
    end 


  end  	


end 

