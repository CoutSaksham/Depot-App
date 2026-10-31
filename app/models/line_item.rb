class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true
end
