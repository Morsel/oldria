require_relative '../../spec_helper'
describe Admin::TraceSearchesController do
	
	describe "GET #index" do
		it "populates an array of trace search" do
		 trace_search = 	FactoryGirl.create(:trace_search)
		  get :index
		  assigns(:trace_searches).should eq([trace_search])
		end

		it "renders the :index view" do
		 	get :index
		 	response.should render_template :index
		 end
	end 	

	describe "GET #trace_search_for_soapbox" do
		it "populates an array of trace search for spoonfeed" do 
		 spoonfeed_trace_searche = 	FactoryGirl.create(:spoonfeed_trace_searche)
		  get :trace_search_for_soapbox
  	  assigns(:soapbox_trace_searches).should eq([spoonfeed_trace_searche])
		end

		it "renders the :trace_search_for_soapbox view" do
		 	get :trace_search_for_soapbox
		 	response.should render_template :trace_search_for_soapbox
		 end
	end 	

end 	
