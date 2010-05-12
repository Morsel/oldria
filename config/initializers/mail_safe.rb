# This is a development-only configuration
if defined?(MailSafe::Config)
  MailSafe::Config.internal_address_definition = lambda { |address|
    address =~ /.*@neotericdesign\.com/i ||
    address =~ /.*@restaurantintelligenceagency\.com/i ||
    address == 'aeschright@elevatedrails.com'
  }

  MailSafe::Config.replacement_address = lambda { |address|
    "josh+#{address.gsub(/[\w\-.]/, '_')}@neotericdesign.com" }
end
