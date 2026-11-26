class Product < ApplicationRecord
  MINIMUM_DESCRIPTION_WORDS = 5
  MAXIMUM_DESCRIPTION_WORDS = 10
  EXACT_NUMBER_OF_PERMALINK_WORDS = 3
  DEFAULT_TITLE = "abc".freeze
  MAXIMUM_NUMBER_OF_PHOTOS = 3

  has_many :line_items, dependent: :restrict_with_error
  has_many :carts, through: :line_items
  belongs_to :category, counter_cache: true
  has_many_attached :images

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

  validate :max_three_images

  before_validation :set_default_title, unless: -> { title.present? }
  before_validation :set_default_discount_price, unless: -> { discount_price.present? }
  after_create -> { update_related_category_parent_counter(1) }
  after_destroy -> { update_related_category_parent_counter(-1) }
  before_update -> { update_related_category_parent_counter(-1) },
                if: :will_save_change_to_category_id?
  after_update -> { update_related_category_parent_counter(1) },
                if: :saved_change_to_category_id?
  
  scope :enabled, -> { where(enabled: true) }
  scope :associated_with_line_item, -> { joins(:line_items).distinct }

  def self.has_line_item_titles
    associated_with_line_item.pluck(:title)
  end

  private def update_related_category_parent_counter(num)
    category = Category.find(category_id_in_database)
    category.update_parent_counter(num) if category.parent_category_id.present?
  end

  private def max_three_images
    if images.attachments.size > MAXIMUM_NUMBER_OF_PHOTOS
      errors.add[:images, "Cannot upload more than #{MAXIMUM_NUMBER_OF_PHOTOS}"]
    end
  end

  private def update_related_category_parent_counter(num)
    category = Category.find(category_id_in_database)
    category.update_parent_counter(num) if category.parent_category_id.present?
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
