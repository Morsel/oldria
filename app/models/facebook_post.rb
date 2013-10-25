class FacebookPost < SocialPost
  attr_accessible :post_at, :content,:payload_object, :priority, :run_at
  def input_value
    content == source.facebook_message ? '' : content
  end

  def message
    content.blank? ? source.facebook_message : content
  end

  def post
    source.post_to_facebook(content)
  end
end
