# == Schema Information
# Schema version: 20110323195248
#
# Table name: topics
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#  description :string(255)
#  type        :string(255)
#

class RestaurantTopic < Topic

  has_many :restaurant_questions, :through => :restaurants

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
