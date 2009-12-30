namespace :export do
  desc "Export users to users.csv"
  task :users => :environment do
    File.open(RAILS_ROOT + "/users.csv", "w") do |csv|
      csv.write(User.to_csv)
    end
  end
end