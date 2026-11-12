class UrlValidator < ActiveModel::EachValidator
<<<<<<< HEAD
  def validate_each(record, attribute, value)
    if value.present? && !value.match?(IMAGE_URL_FORMAT)
      record.errors.add(attribute, "Must be a valid URL in image format")
    end
  end
end
=======
  URLFORMAT = /\.(?:gif|jpg|jpeg|png)\z/

  def validate_each(record, attribute, value)
    if value.present? && !value.match?(URLFORMAT)
      record.errors.add(attribute, "Must be in image format")
    end
  end
end
<<<<<<< HEAD
>>>>>>> 84be896 (Added validations in products, line_items and users models)
=======
>>>>>>> 34d4144 (Fix email validation security warning)
