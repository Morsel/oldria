module SoapboxHelper

  def resource_for_featured_item(soapbox_entry)
    return unless soapbox_entry.featured_item.present?
    if soapbox_entry.featured_item.class.to_s =~ /Admin::/
      soapbox_entry.featured_item
    else
      [:admin, soapbox_entry.featured_item]
    end
  end

end
