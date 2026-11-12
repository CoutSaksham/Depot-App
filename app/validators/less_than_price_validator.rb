class LessThanPriceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && value >= record.price
      record.errors.add(attribute, "Must be less than price")
    end
  end
end
