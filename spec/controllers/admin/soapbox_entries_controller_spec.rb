require_relative '../spec_helper'

describe Admin::SoapboxEntriesController do
  integrate_views
  before do
    fake_admin_user
  end

  describe "GET index" do
    before do
      get :index
    end

    it { response.should be_success }
  end

  describe "GET new" do
    context "with a QOTD" do
      before do
        @qotd = Factory.stub(:qotd)
        Admin::Qotd.expects(:find).with('3').returns(@qotd)
        get :new, :qotd_id => 3
      end

      it "should assign @qotd" do
        assigns[:featured_item].should == @qotd
      end
    end

    context "with a Trend Question" do
      before do
        @trend_question = Factory.stub(:trend_question)
        TrendQuestion.expects(:find).with('45').returns(@trend_question)
        get :new, :trend_question_id => 45
      end

      it "should assign @trend_question" do
        assigns[:featured_item].should == @trend_question
      end
    end

    context "with neither a QOTD or Trend Question" do
      it "should not assign @featured_item" do
        get :new
        assigns[:featured_item].should be_nil
      end
    end
  end

  describe "POST create" do
    context "when model is valid" do
      before do
        SoapboxEntry.any_instance.stubs(:valid?).returns(true)
        post :create
      end

      it { response.should redirect_to admin_soapbox_entries_path }
    end

    context "when model is invalid" do
      before do
        SoapboxEntry.any_instance.stubs(:valid?).returns(false)
        post :create
      end

      it { response.should render_template(:new) }
    end
  end

  describe "GET edit" do
    context "with a QOTD" do
      before do
        @qotd = Factory.stub(:qotd)
        @soapbox_entry = Factory.stub(:soapbox_entry, :featured_item => @qotd)
        SoapboxEntry.expects(:find).returns(@soapbox_entry)
        get :edit, :id => 1
      end

      it "should assign @soapbox_entry" do
        assigns[:soapbox_entry].should == @soapbox_entry
      end
    end
  end

  describe "PUT update" do
    before do
      @soapbox_entry = Factory(:soapbox_entry)
      SoapboxEntry.stubs(:find).returns(@soapbox_entry)
    end

    context "when model is valid" do
      before do
        @soapbox_entry.stubs(:valid?).returns(true)
        put :update, :id => 101
      end

      it { response.should redirect_to admin_soapbox_entries_path }
    end

    context "when model is invalid" do
      before do
        @soapbox_entry.stubs(:valid?).returns(false)
        put :update, :id => 101
      end

      it { response.should render_template(:edit) }
    end
  end
  
  describe "status changes" do
    
    it "should unpublish an entry" do
      entry = Factory(:soapbox_entry)
      SoapboxEntry.stubs(:find).returns(entry)
      entry.expects(:update_attribute).with(:published, false)
      
      post :toggle_status, :id => entry.id
    end

    it "should publish an entry" do
      entry = Factory(:soapbox_entry, :published => false)
      SoapboxEntry.stubs(:find).returns(entry)
      entry.expects(:update_attribute).with(:published, true)
      
      post :toggle_status, :id => entry.id
    end

  end
  
end
