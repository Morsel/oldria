class WpBlogPost < ActiveRecord::Base
  octopus_establish_connection(:adapter => "mysql2", :database => "soapbox_wp" ,:password => "2x5qhe1lY2", :username=>"ria_staging")
  set_primary_key 'id'
  set_table_name "wp_posts"
  #Only in case you want to add comments as well:

end
