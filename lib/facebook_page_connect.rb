module FacebookPageConnect

  def has_facebook_page?
    facebook_page_id.present? and facebook_page_token.present?
  end

  def facebook_page
    @page ||= Mogli::Page.new(:id => facebook_page_id, :client => Mogli::Client.new(facebook_page_token))
  end

  def post_to_facebook_page(post_params)
    facebook_page.feed_create(Mogli::Post.new(post_params))
  rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException => e
    Rails.logger.error("Unable to post to Facebook page #{facebook_page_id} due to #{e.message}")
  end

end