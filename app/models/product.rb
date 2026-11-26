class Product < ApplicationRecord
  MINIMUM_DESCRIPTION_WORDS = 5
  MAXIMUM_DESCRIPTION_WORDS = 10
  EXACT_NUMBER_OF_PERMALINK_WORDS = 3
  DEFAULT_TITLE = "abc".freeze

  has_many :line_items, dependent: :restrict_with_error
  has_many :carts, through: :line_items

  validates :title, :description, :image_url, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, uniqueness: true

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
  validates :discount_price, numericality: { less_than_or_equal_to: :price }

  before_validation :set_default_title, unless: -> { title.present? }
  before_validation :set_default_discount_price, unless: -> { discount_price.present? }

  scope :enabled, -> { where(enabled: true) }
  scope :associated_with_line_item, -> { joins(:line_items).distinct }

  def self.has_line_item_titles
    associated_with_line_item.pluck(:title)
  end

  private def description_words
    description ? description.scan(WORDS) : []
  end

  private def permalink_words
    permalink ? permalink.split("-") : []
  end

  private def set_default_title
    self.title = DEFAULT_TITLE
  end

  private def set_default_discount_price
    self.discount_price = self.price
  end
end
