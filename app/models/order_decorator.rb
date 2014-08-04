 Spree::Order.class_eval do

    checkout_flow do
      go_to_state :address
      go_to_state :delivery
      go_to_state :payment, if: ->(order) do
        # TODO there should be a better fix work around for the issues this is
        # resolving we shouldn't be setting shipments cost every time a order
        # object is loaded
        order.set_shipments_cost if order.shipments.any?
        order.payment_required?
      end
      go_to_state :confirm, if: ->(order) { order.confirmation_required? }
      go_to_state :complete
      remove_transition from: :delivery, to: :confirm
     # remove_checkout_step :delivery

    end


    
end