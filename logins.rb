### Needs Email Confirmation Somehow why we do not know!
logins = <<-EOT.split(/\n/)
JustinCogley
IanGoldberg
AndrewJohnson
MatthewKirkley
TomislavLokvicic
DanPilkey
KatieRenton
LizSymon
AlissaWallers
EOT

require 'rubygems'
require 'safariwatir'

browser = Watir::Safari.new
browser.speed = :fast

logins.each do |login|
  browser.goto("http://spoonfeed.restaurantintelligenceagency.com/login")
  browser.text_field(:name, "user_session[username]").set(login)
  browser.text_field(:name, "user_session[password]").set("welcome")
  form = browser.image(:alt, "Key")
  form.click
  sleep 1
  if browser.contains_text("Your Digital Dashboard")
    browser.goto("http://spoonfeed.restaurantintelligenceagency.com/logout")
  else
    puts "*** FAILURE: Couldn't log in '#{login}\n"
  end
end
