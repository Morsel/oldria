class SoapboxController < ApplicationController

  def index
    @main_soapbox_entry = SoapboxEntry.trend_question.first(:include => :featured_item)
    @featured_trend_question = @main_soapbox_entry.try(:featured_item)

    @qotds = SoapboxEntry.qotd.all(:include => :featured_item)
  end

end
