require 'date'

class Date
  def dayname
     DAYNAMES[self.wday].capitalize
  end

  def abbr_dayname
    ABBR_DAYNAMES[self.wday]
  end
end