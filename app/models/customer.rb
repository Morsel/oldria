class Customer
  attr_accessor :credit_card

  def initialize
    self.credit_card = CreditCard.new
  end

  class CreditCard
    attr_accessor :number, :cvv, :expiration_month, :expiration_year, :billing_address

    def initialize
      self.billing_address = BillingAddress.new
    end

    class BillingAddress
      attr_accessor :postal_code
    end
  end
end