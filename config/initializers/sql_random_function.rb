
if ActiveRecord::Base.connection.adapter_name.eql?("SQLite")
  RANDOM_SQL_STRING = 'RANDOM()'
else
  RANDOM_SQL_STRING = 'RAND()'
end
