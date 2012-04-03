DEFAULT_SUBDOMAIN = if Rails.env.production?
  'spoonfeed'
elsif Rails.env.staging?
  'staging'
else
  ''
end

SubdomainFu.tld_sizes = {
  :development => 2,
  :test => 1,
  :staging => 2,
  :production => 1
}