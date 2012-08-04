class WpBlogPost < ActiveRecord::Base
	establish_connection :blog
  set_primary_key 'id'
  set_table_name "wp_posts"
  #Only in case you want to add comments as well:

end
