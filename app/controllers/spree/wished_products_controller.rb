class Spree::WishedProductsController < Spree::StoreController

  def create
    @wished_product = Spree::WishedProduct.new(wished_product_attributes)
    @wishlist = spree_current_user.wishlist
    @line_item_id = params[:line_item_id]

    if @wishlist.include? params[:wished_product][:variant_id]
      @wished_product = @wishlist.wished_products.detect { |wp| wp.variant_id == params[:wished_product][:variant_id].to_i }
    else
      @wished_product.wishlist = spree_current_user.wishlist
      
      # if @wished_product.save
      #   # Spree::WishedProduct.delete_wished_product_from_order(current_order, @wished_product)
      # end
    end


    if @wished_product.save
      respond_to do |format|
        format.html { redirect_to root_path}
        format.js
      end
    end

  end

  def update
    @wished_product = Spree::WishedProduct.find(params[:id])
    @wished_product.update_attributes(wished_product_attributes)

    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wished_product.wishlist) }
    end
  end

  def destroy
    @wished_product = Spree::WishedProduct.find(params[:id])
    @wished_product.destroy
    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

  private

  def wished_product_attributes
    params.require(:wished_product).permit(:variant_id, :wishlist_id, :remark, :quantity)
  end
end
