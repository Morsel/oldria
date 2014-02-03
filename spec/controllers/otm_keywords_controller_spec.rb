require_relative '../spec_helper'

describe OtmKeywordsController  do
 #integrate_views

it "should render js" do
  get :index
  @request.env['HTTP_ACCEPT'] = 'text/javascript'
end
  
it "should render js" do
  get :auto_complete_otmkeywords
  response.should be_success
end

end   