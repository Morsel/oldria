module PageFeatures

  def generate_slug!
    return slug unless slug.blank?
    self.slug = Slug.normalize(title)
  end

  def deletable?
    not special?
  end

  def special?
    SPECIAL.include?(slug)
  end
  
end