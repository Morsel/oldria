# These settings are for Mail Safe gem
#
# http://github.com/myronmarston/mail_safe
#
#   gem install mail_safe
#
# We are currently using mail_safe for development and staging environments
# so that we can use real (read complex) data without having emails sent to an
# inappropriate place.
if defined?(MailSafe::Config)
  MailSafe::Config.internal_address_definition = lambda { |address|
    address =~ /.*@neotericdesign\.com/i ||
    address =~ /.*@restaurantintelligenceagency\.com/i ||
    address == 'aeschright@elevatedrails.com' ||
    address == 'nicole.schnitzler@gmail.com'
  }

  MailSafe::Config.replacement_address = lambda { |address|
    "testuser+#{address.gsub(/[^\w\d\-\_]/, '_')}@restaurantintelligenceagency.com" }
end
