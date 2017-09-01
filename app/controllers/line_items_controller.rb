class LineItemsController < ApplicationController
  skip_before_filter :authorize, :only => [:create]
  
  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html  { redirect_to(store_url) }
        format.js { @current_item = @line_item }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end
end
