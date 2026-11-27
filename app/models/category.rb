class Category < ApplicationRecord
  belongs_to :parent_category, class_name: "Category", optional: true
  has_many :sub_categories, class_name: "Category", foreign_key: :parent_category_id, dependent: :destroy
  has_many :products, dependent: :restrict_with_error
  has_many :subcategory_products, through: :sub_categories, source: :products

  validates :name, presence: true
  validates :name, uniqueness: { conditions: -> { where(parent_category_id: nil) } }, if: -> { name.present? }
  validates :name, uniqueness: { scope: :parent_category_id }, if: -> { name.present? && parent_category_id.present? }
  validate :is_parent_a_sub_category?, if: -> { parent_category_id.present? }

  before_destroy :ensure_subcategory_not_referenced_by_any_product, prepend: true

  def update_parent_counter(num)
    parent = Category.find(self.parent_category_id)
    parent.increment!(:products_count, num)
  end

  private def ensure_subcategory_not_referenced_by_any_product
    sub_categories.each do |cat|
      if cat.products_count > 0
        errors.add(:base, "Cannot delete category because a Product is associated with a subcategory")
        throw :abort
      end
    end
  end

  private def is_parent_a_sub_category?
    errors.add(:parent_category, "Cannot make a subcategory the parent category") if Category.find(self.parent_category_id).parent_category_id.present?
  end
end
