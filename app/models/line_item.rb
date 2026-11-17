class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true, counter_cache: true

  validates :product_id, uniqueness: { scope: :cart_id }
end
