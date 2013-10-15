class WpBlogPost < ActiveRecord::Base
  octopus_establish_connection(:adapter => "mysql", :database => "soapbox_wp" ,:password => "xZtsxibg9J34", :username=>"soapbox_db")
  set_primary_key 'id'
  set_table_name "wp_posts"
  #Only in case you want to add comments as well:

end



