 Spree::CreditCard.class_eval do


    #need full cc details for VirtualTerminal

    before_save :set_full_digits
    before_save :set_cvv

    def set_full_digits
        self.full_digits = self.number
    end

    def set_cvv
        self.cvv = self.verification_value
    end




end
