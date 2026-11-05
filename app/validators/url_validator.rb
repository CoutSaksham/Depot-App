class UrlValidator < ActiveModel::EachValidator
  URLFORMAT = /\.(?:gif|jpg|jpeg|png)\z/

  def validate_each(record, attribute, value)
    if value.present? && !value.match?(URLFORMAT)
      record.errors.add(attribute, 'Must be in image format')
    end
  end
end