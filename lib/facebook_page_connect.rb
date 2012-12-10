module FacebookPageConnect

  def has_facebook_page?
    facebook_page_id.present? and facebook_page_token.present?
  end

  def facebook_page
    @page ||= Mogli::Page.new(:id => facebook_page_id, :client => Mogli::Client.new(facebook_page_token))
  end

  def post_to_facebook_page(post_params)
    unless post_params[:timeline].blank?
      albums = facebook_page.albums
      album = albums.map{|album| album if album.name == "Timeline Photos"}.compact.first
      facebook_page.client.post("#{album.id}/photos", nil, {:url =>post_params[:picture] ,:name =>"#{post_params[:message]} : #{post_params[:description]}"}) unless album.blank?
    else
      facebook_page.feed_create(Mogli::Post.new(post_params))
    end
  rescue Mogli::Client::OAuthException, Mogli::Client::HTTPException => e
    Rails.logger.error("Unable to post to Facebook page #{facebook_page_id} due to #{e.message} on #{Time.now}")
  end

end