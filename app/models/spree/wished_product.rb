class Spree::WishedProduct < ActiveRecord::Base

  belongs_to :variant
  belongs_to :wishlist

  scope :sort_alphabatical_by_name, -> {includes(variant: {product: :translations}).order("spree_product_translations.name ASC")}


  def self.delete_wished_product_from_order(current_order, wished_product)
    
    matched_line_item = current_order.present? ?  current_order.line_items.where("variant_id=?", wished_product.variant_id).last : ""
  	
    if matched_line_item.present?
  	 matched_line_item.delete 
  	 current_order.update(item_count: current_order.item_count - matched_line_item.quantity)
  	end
    
  end
  
  def total
    quantity * variant.price
  end

  def display_total
    Spree::Money.new(total)
  end

end
