class User < ApplicationRecord
  ADMIN_EMAIL = "admin@depot.com".freeze

  has_many :orders
  has_many :line_items, through: :orders
  has_secure_password

  validates :name, presence: true
  validates :email, uniqueness: true,
    format: {
      with: EMAIL_FORMAT,
      message: "must be a valid email address"
    }

  after_destroy :ensure_an_admin_remains
  after_create_commit :send_welcome_mail
  before_destroy :ensure_admin_is_not_destroyed
  before_update :ensure_admin_is_not_updated

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
    return unless is_admin?

    errors.add(:base, "Cannot destroy the admin")
    throw :abort
  end

  private def ensure_admin_is_not_updated
    return unless was_admin?

    errors.add(:base, "Cannot update the admin")
    throw :abort
  end

  private def is_admin?
    email == ADMIN_EMAIL
  end

  private def was_admin?
    email_in_database == ADMIN_EMAIL
  end
end
