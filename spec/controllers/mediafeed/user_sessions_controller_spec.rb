require_relative '../../spec_helper'

describe Mediafeed::UserSessionsController do

  describe "GET 'new'" do
    it "should redirect" do
      get 'new'
      response.should be_redirect
    end
  end
end
