class ShipmentsController < ActionController::Base

  
  
  def index
  #  @outstanding_orders = Spree::Order.where(payment_state: 'paid').where(shipment_state: 'ready')
    @outstanding_orders = Spree::Order.all
  end
  
  
  def update_order
    
    
    @order = Spree::Order.find(params[:order][:id])
    
    # we are re-using this attribute because I cant add attr_accessor for tracking 
    if params[:order][:special_instructions]
      
    #  Rails.logger.info params[:order][:special_instructions]
      @shipment = @order.shipments.first
      
      @shipment.tracking = params[:order][:special_instructions]
      @shipment.state = "shipped"  
      @shipment.shipped_at = DateTime.now
      @shipment.save
      
      @order.shipment_state = "shipped"
      @order.save
      
      
    else
      
    end
    
  end
  

end