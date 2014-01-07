require_relative '../spec_helper'

describe StatesController do
  integrate_views


  describe "GET index" do
    it "get all action for state keyword" do
      get :auto_complete_statekeywords, :format => 'js'
      @request.accept = "text/javascript"
    end
  end

  describe "auto_complete_statekeywords" do 
    it "assigns the autocomplete for state keyword" do
     state_keyword_name = "test"
     get :auto_complete_statekeywords,:state_keyword_name=>"test", :format => 'js'
     @request.accept = "text/javascript"
    end  
  end   
   
  describe "get state name" do    
    it "get all the state name" do
      state_keyword_name = "test"
    end   
 end 
end

