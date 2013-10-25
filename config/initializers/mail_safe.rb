
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
  
# anything defined here will be allowed to go through 

  MailSafe::Config.internal_address_definition = lambda { |address|
    address =~ /.*@neotericdesign\.com/i ||
    address =~ /.*@restaurantintelligenceagency\.com/i ||
    address =~ /.*@elevatedrails\.com/i ||
    address =~ /nicole\.schnitzler.*@gmail\.com/ ||
    address =~ /craigulliott.*@gmail\.com/
  }

# everything else is going to be sent to this address
# FYI: this is a google mail list

  MailSafe::Config.replacement_address = lambda { |address|
    "testuser+#{address.gsub(/[^\w\d\-\_]/, '_')}@restaurantintelligenceagency.com" }
end
