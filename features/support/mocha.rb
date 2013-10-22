# require "mocha"
require 'mocha/setup'
require "delorean"

World(Delorean)
World(Mocha::API)

Before do
  mocha_setup
end

After do
  begin
    mocha_verify
  ensure
    back_to_the_present
    mocha_teardown
  end
end

Spec::Matchers.define :have_avatar do
  match { |user| user.avatar? }
end
