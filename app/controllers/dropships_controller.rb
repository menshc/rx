class DropshipsController < ActionController::Base # as opposed to Spree::OrdersController



   http_basic_authenticate_with name: "thc4u", password: "tetra"#, except: :index



    respond_to :json, :js, :html


    def show
    end
  
  def index
  #  @outstanding_orders = Spree::Order.where(payment_state: 'paid').where(shipment_state: 'ready')

 
    if params.has_key? 'filter' and params[:filter] == 'all'

     @orders  = Spree::Order.all

    elsif params.has_key? 'filter' and params[:filter] == 'unshipped'


          @orders = Spree::Order.where(payment_state: 'paid').where.not(shipment_state: 'shipped')

    elsif params.has_key? 'filter' and params[:filter] == 'shipped'


          @orders = Spree::Order.where(payment_state: 'paid').where(shipment_state: 'shipped')
    
    else
         
          @orders = Spree::Order.where.not(payment_state: 'paid')

    end

  end
  
  
  def update
    
     
    order = Spree::Order.find(params[:id])  #or number

    order.update_attributes(order_params)



  # we are re-using this attribute because I cant add attr_accessor for tracking 
    

    if params[:dropship][:special_instructions]


         shipment = order.shipments.first
         
         shipment.tracking = params[:special_instructions]
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
    params.require(:dropship).permit(:payment_state, :special_instructions)
  end
  

end