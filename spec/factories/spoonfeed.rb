Factory.define :user do |f|
  f.sequence(:username) { |n| "foo#{n}" }
  f.sequence(:email)    { |n| "foo#{n}@example.com" }
  f.password 'foobar'
  f.password_confirmation { |u| u.password }
  f.confirmed_at { Time.now }
end

Factory.define :status do |f|
  f.association :user
  f.message     "I just ate a cheeseburger"
end
