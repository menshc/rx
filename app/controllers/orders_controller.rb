class OrdersController < ActionController::Base # as opposed to Spree::OrdersController

    respond_to :json, :js, :html


    def show
    end
  
  def index
  #  @outstanding_orders = Spree::Order.where(payment_state: 'paid').where(shipment_state: 'ready')

 
    if params.has_key? 'filter' and params[:filter] == 'unpaid'

          @orders = Spree::Order.where.not(payment_state: 'paid')
    

    elsif params.has_key? 'filter' and params[:filter] == 'unshipped'


          @orders = Spree::Order.where(payment_state: 'paid').where.not(shipment_state: 'shipped')

    elsif params.has_key? 'filter' and params[:filter] == 'shipped'


          @orders = Spree::Order.where(payment_state: 'paid').where(shipment_state: 'shipped')
    else

          @orders  = Spree::Order.all

    end

  end
  
  
  def update
    
     
    order = Spree::Order.find(params[:id])  #or number

    order.update_attributes(order_params)


    if params[:mark_shipped_with_tracking]


         shipment = order.shipments.first
         
         shipment.tracking = params[:mark_shipped_with_tracking]
         shipment.state = "shipped"  
         shipment.shipped_at = DateTime.now
         shipment.save
         
         order.shipment_state = "shipped"
         order.save


    end



    render json: order



#   if params[:order][:payment_state]

#     #....

#   end
#   
#   # we are re-using this attribute because I cant add attr_accessor for tracking 
#   if params[:order][:special_instructions]
#     
#   #  Rails.logger.info params[:order][:special_instructions]
#     @shipment = @order.shipments.first
#     
#     @shipment.tracking = params[:order][:special_instructions]
#     @shipment.state = "shipped"  
#     @shipment.shipped_at = DateTime.now
#     @shipment.save
#     
#     @order.shipment_state = "shipped"
#     @order.save
#     
#     
#   else
#     
#   end
    
  end


  private

  def order_params
    params.require(:order).permit(:payment_state).permit(:mark_shipped_with_tracking)
  end
  

end