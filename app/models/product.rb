class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true
  # validates :image_url, allow_blank: true, format: {
  # with: %r{\.(gif|jpg|png)\z}i,
  # message: 'must be a URL for GIF, JPG or PNG image.'
  # }
  # validates :title, length: {minimum: 10}
  validates :permalink, uniqueness: { case_sensitive: false },
            format: {
              with: ONLY_LETTERS_NUMBERS_AND_HYPHENS,
              message: "Cannot have special characters or spaces"
            }, allow_blank: true

  validates :permalink_words, length: { is: EXACT_NUMBER_OF_PERMALINK_WORDS }, allow_blank: true

  validates_length_of :description_words,
            in: MINIMUM_DESCRIPTION_WORDS..MAXIMUM_DESCRIPTION_WORDS,
            too_short: "must be longer than #{MINIMUM_DESCRIPTION_WORDS}",
            too_long: "must be shorter than #{MAXIMUM_DESCRIPTION_WORDS}",
            allow_blank: true

  validates :image_url, url: true
  validates :discount_price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :discount_price, less_than_price: true
  validates :discount_price, numericality: { less_than: :price }

  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  private def ensure_not_referenced_by_any_line_item
    unless line_item.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end

  private def description_words
    description ? description.scan(WORDS) : []
  end

  private def permalink_words
    permalink ? permalink.split("-") : []
  end
end
