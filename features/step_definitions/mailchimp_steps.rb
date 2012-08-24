Given /^Mailchimp is set up$/ do
  client = mock
  mc = mock
  MailchimpConnector.stubs(:new).returns(mc)
  mc.stubs(:client).returns(client)
  mc.stubs(:mailing_list_id).returns(1234)
  client.stubs(:list_subscribe).returns(true)
end
