DEFAULT_SUBDOMAIN = if Rails.env.production?
  'spoonfeed'
elsif Rails.env.staging?
  'staging'
else
  ''
end

SubdomainFu.tld_sizes = {
  :development => 0,
  :test => 1,
  :staging => 1,
  :production => 1
}