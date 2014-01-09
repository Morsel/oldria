require_relative '../spec_helper'

describe CoachedStatusUpdate do
  it "should be valid" do
    CoachedStatusUpdate.new.should be_valid
  end
end

describe CoachedStatusUpdate, "date ranges" do

  before(:each) do
    @christmas = FactoryGirl.create(:date_range, :start_date => Date.parse('2009-12-01'), :end_date => Date.parse('2009-12-26'))
    @summer = FactoryGirl.create(:date_range, :start_date => Date.parse('2009-06-20'), :end_date => Date.parse('2009-09-20'))
    Date.stubs(:today).returns(Date.parse('2009-08-01'))
  end

  context "without randomization" do
    it "should return current messages" do
      summer_message = FactoryGirl.create(:coached_status_update, :date_range => @summer)
      CoachedStatusUpdate.current.should include(summer_message)
    end

    it "should not return message out of the date range" do
      christmas_message = FactoryGirl.create(:coached_status_update, :date_range => @christmas)
      CoachedStatusUpdate.current.should_not include(christmas_message)
    end
  end

  context "with randomization" do
    it "should return one status update" do
      message1 = FactoryGirl.create(:coached_status_update, :date_range => @summer)
      CoachedStatusUpdate.current.random.length.should == 1
    end

    it "should return one of three messages between 20 and 50 times out of 100" do
      message1 = CoachedStatusUpdate.create!(:date_range => @summer, :message => 'a')
      message2 = CoachedStatusUpdate.create!(:date_range => @summer, :message => 'b')
      message3 = CoachedStatusUpdate.create!(:date_range => @summer, :message => 'c')
      @count = 0
      100.times do
        if message2.id == CoachedStatusUpdate.current.random.first.id
          @count +=1
        end
      end
      @count.should be_between(20,45)
    end
  end

  describe "#seasons" do
    it "should return the all seasons" do
      coached_status_updates = FactoryGirl.create(:coached_status_update)
      CoachedStatusUpdate.seasons.should ==  @@seasons ||= %w{Winter Spring Summer Fall}
    end   
  end

  describe "#holidays" do
    it "should return the all holidays" do
      coached_status_updates = FactoryGirl.create(:coached_status_update)
      CoachedStatusUpdate.holidays.should ==  @@holidays ||= %w{Christmas Hannukah Thanksgiving Labor_Day}.map {|s| s.gsub(/_/, ' ')}
    end   
  end


end
