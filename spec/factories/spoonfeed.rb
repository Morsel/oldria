Factory.define :user do |f|
  f.sequence(:username) { |n| "foo#{n}" }
  f.sequence(:email)    { |n| "foo#{n}@example.com" }
  f.password 'foobar'
  f.password_confirmation { |u| u.password }
  f.confirmed_at { Time.now }
end

Factory.define :admin, :parent => :user do |f|
  f.admin true
  f.username 'admin'
end

Factory.define :status do |f|
  f.association :user
  f.message     "I just ate a cheeseburger"
end

Factory.define :twitter_user, :parent => :user do |f|
  f.atoken  'fake'
  f.asecret 'fake'
end