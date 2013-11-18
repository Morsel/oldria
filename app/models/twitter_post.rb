class TwitterPost < SocialPost
	attr_accessible :post_at, :content,:payload_object, :priority, :run_at
  def input_value
    content == source.twitter_message ? '' : content
  end
  
  def message
    content.blank? ? source.twitter_message : content
  end
  
  def post
    source.post_to_twitter(content)
  end
end
