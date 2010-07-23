class SoapboxController < ApplicationController

  def index
    @featured_trend_question = SoapboxEntry.featured_trend_question
    @featured_tq_comments = SoapboxEntry.featured_trend_question_comments if @featured_trend_question
    
    @featured_qotd = SoapboxEntry.featured_qotd
    @featured_qotd_comments = SoapboxEntry.featured_qotd_comments if @featured_qotd

    @qotds = SoapboxEntry.qotd.published.recent.all(:include => :featured_item).map(&:featured_item)
    @trend_questions = SoapboxEntry.trend_question.published.recent.all(:include => :featured_item).map(&:featured_item)
  end

end
