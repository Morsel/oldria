DEFAULT_SUBDOMAIN = if Rails.env.production?
  'spoonfeed'
elsif Rails.env.staging?
  'staging'
else
  ''
end

SubdomainFu.tld_size = 1