class MailchimpConnector

  attr_accessor :client

  def initialize
    @client = Gibbon.new
  end

  def mailing_list_id
    @mailing_list_id ||= client.lists(:filters => { :name => "Soapbox Newsletter" })['data'].first['id']
  end

  def grouping_id
    @grouping_id ||= client.list_interest_groupings(:id => mailing_list_id).first['id']
  end

  # Code for media sinup 
  def media_promotion_list_id
    @media_promotion_list_id ||= client.lists({:filters=>{:list_name=>"Media Newsletter"}})['data'].first['id']    
  end 

  def get_mpl_groups
    @list ||= client.list_interest_groupings({:id=>media_promotion_list_id})
    groups = {}
     @list.each do |row|
      groups["#{row['name']}"] = row
     end 
     groups
  end  
end