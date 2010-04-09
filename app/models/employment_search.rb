class EmploymentSearch < ActiveRecord::Base
  has_one :trend_question
  has_one :holiday

  serialize :conditions


  def employments
    Employment.search(conditions)
  end

end
