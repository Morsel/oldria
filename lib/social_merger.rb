class SocialMerger

  attr_accessor :sorted_updates

  def initialize(twitter_updates, facebook_updates, alm_answers)
    self.sorted_updates = (twitter_updates + facebook_updates + alm_answers).sort { |a, b| b[:created_at] <=> a[:created_at] }
  end

end