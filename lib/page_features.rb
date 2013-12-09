module PageFeatures

  SPECIAL = %w(about contact welcome_new_user sales home about_media home_media)

  def generate_slug!
    return slug unless slug.blank?
      # unless slug.blank?
        # self.slug = Slug.normalize(title)
        #CIS http://stackoverflow.com/questions/10776706/rails-friendlyid-and-normalize-friendly-id
        self.slug = title.to_s.gsub("\'", "").parameterize
      # end  
  end

  def deletable?
    not special?
  end

  def special?
    SPECIAL.include?(slug)
  end
  
end