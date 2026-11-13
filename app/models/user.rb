class User < ApplicationRecord
  has_secure_password
  after_destroy :ensure_an_admin_remains
  after_create :send_welcome_mail
  before_destroy :ensure_admin_is_not_destroyed
  before_update :ensure_admin_is_not_updated

  validates :name, presence: true
  validates :email, uniqueness: true,
    format: {
      with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/,
      message: "must be a valid email address"
    }

  class Error < StandardError
  end

  private def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end

  private def send_welcome_mail
    UserMailer.greet(self).deliver_now
  end

  private def ensure_admin_is_not_destroyed
    if email == "admin@depot.com"
      errors.add(:base, "Cannot destroy the admin")
      throw :abort
    end
  end

  private def ensure_admin_is_not_updated
    if email_in_database == "admin@depot.com"
      errors.add(:base, "Cannot update the admin")
      throw :abort
    end
  end
end
