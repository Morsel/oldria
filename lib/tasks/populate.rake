namespace :db do
  desc "Add 25 fake users"
  task :populate => :environment do
    begin
      require 'faker'

      25.times do
        u                       = User.new
        u.first_name            = Faker::Name.first_name
        u.last_name             = Faker::Name.last_name
        u.email                 = Faker::Internet.email
        u.username              = Faker::Internet.user_name(u.first_name)
        u.password              = 'password'
        u.password_confirmation = 'password'
        u.confirmed_at          = Time.now
        u.save
      end
    rescue LoadError
      "You need the populator and faker gems"
    end
  end
end

