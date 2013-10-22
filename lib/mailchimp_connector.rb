class MailchimpConnector

  attr_accessor :client

  def initialize name = 'RIA Diners'
    @client = Gibbon.new(ENV['MAILCHIMP_API_KEY'])
    @group_name = name
  end

  def mailing_list_id
    @mailing_list_id ||= client.lists(:filters => { :list_name => "RIA Diners" })['data'].first['id']
  end

  def grouping_id
    @grouping_id ||= client.list_interest_groupings(:id => mailing_list_id).first['id']
  end

  # Code for media sinup 
  def media_promotion_list_id
    @media_promotion_list_id ||= client.lists({:filters=>{:list_name=>@group_name}})['data'].first['id']    
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