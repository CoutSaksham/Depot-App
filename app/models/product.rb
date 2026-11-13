class Product < ApplicationRecord
  has_many :line_items

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 } # price presence validity is not needed since numericality automatically converts emtpy and only whitespace conaitning strings to nil and also rejects nil values
  validates :title, uniqueness: true
  # validates :image_url, allow_blank: true, format: {
  # with: %r{\.(gif|jpg|png)\z}i,
  # message: 'must be a URL for GIF, JPG or PNG image.'
  # }
  # validates :title, length: {minimum: 10}
  validates :permalink, uniqueness: true

  validates :permalink,
            format: {
              with: /\A[a-zA-Z0-9\-]+\z/,
              message: "Cannot have special characters or spaces"
            }

  validates :permalink,
            format: {
              with: /\A(?:[^\-]+-){2,}\w+\z/,
              message: "Cannot be less than 3 words and words have to be hyphen separated"
            }

  validates :description, format: { with: /\A(?:\w+\s){4,9}\w+\z/, message: "Should be between 5 and 10 words" }
  validates :image_url, url: true
  validates :discount_price, less_than_price: true
  validates :discount_price, numericality: { less_than_equal_to: :price }

  after_initialize :set_default_title, :set_default_discount_price
  before_destroy :ensure_not_referenced_by_any_line_item

  private def ensure_not_referenced_by_any_line_item
    unless line_item.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end

  private def set_default_title
    self.title ||= "abc"
  end

  private def set_default_discount_price
    self.discount_price ||= self.price
  end
end
