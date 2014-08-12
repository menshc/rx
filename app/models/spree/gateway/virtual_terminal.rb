module Spree
  class Gateway::VirtualTerminal < Gateway

  #  TEST_VISA = ['4111111111111111','4012888888881881','4222222222222']
  #  TEST_MC   = ['5500000000000004','5555555555554444','5105105105105100']
  #  TEST_AMEX = ['378282246310005','371449635398431','378734493671000','340000000000009']
  #  TEST_DISC = ['6011000000000004','6011111111111117','6011000990139424']
#
  #  VALID_CCS = ['1', TEST_VISA, TEST_MC, TEST_AMEX, TEST_DISC].flatten

    attr_accessor :test

    def provider_class
      self.class
    end

    def preferences
      {}
    end

    def create_profile(payment)
      # simulate the storage of credit card profile using remote service
      success = VALID_CCS.include? payment.source.number
      payment.source.update_attributes(:gateway_customer_profile_id => generate_profile_id(success))
    end

    def authorize(money, credit_card, options = {})
       puts '---------------------------authorize---------------------------'
       puts credit_card.to_yaml
       puts '----------number'
       puts credit_card.number
       puts '-----------verification_value'
       puts credit_card.verification_value
       puts '----------------------------------------------------------------'

       if self.valid(credit_card.number)
        ActiveMerchant::Billing::Response.new(true, 'VirtualTerminal Forced success', {}, :test => true, :authorization => '12345', :avs_result => { :code => 'M' })
      else
        ActiveMerchant::Billing::Response.new(false, 'VirtualTerminal: Forced failure', { :message => 'Invalid Credit Card' }, :test => true)
      end
    end

    def purchase(money, credit_card, options = {})
       puts '---------------------------purchase---------------------------'
       puts credit_card.to_yaml
      if self.valid(credit_card.number)
        ActiveMerchant::Billing::Response.new(true, 'VirtualTerminal: Forced success', {}, :test => true, :authorization => '12345', :avs_result => { :code => 'M' })
      else
        ActiveMerchant::Billing::Response.new(false, 'VirtualTerminal: Forced failure', :message => 'Invalid Credit Card', :test => true)
      end
    end

    def credit(money, credit_card, response_code, options = {})
      ActiveMerchant::Billing::Response.new(true, 'VirtualTerminal: Forced success', {}, :test => true, :authorization => '12345')
    end

    def capture(money, authorization, gateway_options)
        puts '---------------------------capture---------------------------'

      if authorization == '12345'
        ActiveMerchant::Billing::Response.new(true, 'VirtualTerminal: Forced success', {}, :test => true)
      else
        ActiveMerchant::Billing::Response.new(false, 'VirtualTerminal: Forced failure', :error => 'Invalid Credit Card', :test => true)
      end

    end

    def void(response_code, credit_card, options = {})
      ActiveMerchant::Billing::Response.new(true, 'VirtualTerminal: Forced success', {}, :test => true, :authorization => '12345')
    end

    def test?
      # Test mode is not really relevant with bogus gateway (no such thing as live server)
      false
    end

    def payment_profiles_supported?
      false
    end

    def actions
      %w(capture void credit)
    end



      # determine if card is valid based on Luhn algorithm
      def valid(number)
        puts '---------------------------valid?'
        digits = ''
        # double every other number starting with the next to last
        # and working backwards
        number.split('').reverse.each_with_index do |d,i|
          digits += d if i%2 == 0
          digits += (d.to_i*2).to_s if i%2 == 1
        end

        # sum the resulting digits, mod with ten, check against 0
        digits.split('').inject(0){|sum,d| sum+d.to_i}%10 == 0

       # puts '=============== !!!!valid always returning true for testing !!!!==========='
       # return true #just for testing
      end




    private
      def generate_profile_id(success)
        record = true
        prefix = success ? 'NC' : 'FAIL'
        while record
          random = "#{prefix}-#{Array.new(6){rand(6)}.join}"
          record = CreditCard.where(:gateway_customer_profile_id => random).first
        end
        random
      end










  end
end
