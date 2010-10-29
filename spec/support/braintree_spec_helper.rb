def subscription_response_stub
  stub(:subscription => stub(:id => "abcd"))
end

def success_stub
  stub(:success? => true)
end

def failure_stub
  stub(:success? => false)
end

def stub_customer_request
  stub(:customer => stub(:credit_cards => [stub(:token => "abcd")]),
      :success? => true)
end
