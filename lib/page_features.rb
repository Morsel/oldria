module PageFeatures

  SPECIAL = %w(about contact welcome_new_user sales home about_media home_media)

  def generate_slug!
    return slug unless slug.blank?
      unless slug.blank?
        self.slug = Slug.normalize(title)
      end  
  end

  def deletable?
    not special?
  end

  def special?
    SPECIAL.include?(slug)
  end
  
end