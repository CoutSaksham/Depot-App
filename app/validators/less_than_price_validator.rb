class LessThanPriceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
<<<<<<< HEAD
    if value.present? && !record.price.nil? && value >= record.price
      record.errors.add(attribute, "Must be less than price")
=======
    if value.present? && value >= record.price
<<<<<<< HEAD
      record.errors.add(attribute, 'Must be less than price')
>>>>>>> 84be896 (Added validations in products, line_items and users models)
=======
      record.errors.add(attribute, "Must be less than price")
>>>>>>> 34d4144 (Fix email validation security warning)
    end
  end
end
