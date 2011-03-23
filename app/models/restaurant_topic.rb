class RestaurantTopic < Topic

  def previous_for_subject(subject, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    if is_self
      Topic.for_subject(subject).first(:conditions => ["topics.#{sort_field} < ?", self.send(sort_field)],
                                 :order => "#{sort_field} DESC")
    else
      Topic.answered_for_subject(subject).first(:conditions => ["topics.#{sort_field} < ?", self.send(sort_field)],
                                          :order => "#{sort_field} DESC")
    end
  end

  def next_for_subject(subject, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    if is_self
      Topic.for_subject(subject).first(:conditions => ["topics.#{sort_field} > ?", self.send(sort_field)],
                                 :order => "#{sort_field} ASC")
    else
      Topic.answered_for_subject(subject).first(:conditions => ["topics.#{sort_field} > ?", self.send(sort_field)],
                                          :order => "#{sort_field} ASC")
    end
  end

end
