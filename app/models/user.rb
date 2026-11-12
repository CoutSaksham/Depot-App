class User < ApplicationRecord
  has_secure_password
  after_destroy :ensure_an_admin_remains

  validates :name, presence: true
  validates :email, uniqueness: true,
    format: {
      with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/,
      message: "must be a valid email address"
    }

  class Error < StandardError
  end

  private
  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end
