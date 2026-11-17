class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && !value.match?(IMAGE_URL_FORMAT)
      record.errors.add(attribute, "Must be a valid URL in image format")
    end
  end
end
