class Spree::WishedProduct < ActiveRecord::Base
  belongs_to :variant
  belongs_to :wishlist

  scope :sort_alphabatical_by_name, -> {includes(variant: {product: :translations}).order("spree_product_translations.name ASC")}

  def total
    quantity * variant.price
  end

  def display_total
    Spree::Money.new(total)
  end

end
