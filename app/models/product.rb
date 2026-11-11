class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  validates :image_url,
          allow_blank: true,
          format: {
            with: /\A.+\.(gif|jpg|png)\z/i,
            message: "must be a URL for GIF, JPG or PNG image."
          }
  # validates :title, length: {minimum: 10}

  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  private

  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "This product cannot be deleted because it has line items.")
      throw :abort
    end
  end
end
