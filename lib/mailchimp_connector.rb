class MailchimpConnector

  attr_accessor :client

  def initialize
    @client = Gibbon.new
  end

  def mailing_list_id
    @mailing_list_id ||= client.lists(:filters => { :name => "Soapbox Newsletter" })['data'].first['id']
  end

end