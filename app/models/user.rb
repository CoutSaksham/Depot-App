class User < ApplicationRecord
  has_secure_password
  after_destroy :ensure_an_admin_remains

  validates :name, presence: true
  validates :email, uniqueness: true,
                    format: { with: /@[a-z]+\.[a-z]+\z/, message: 'Email should end in @xyz.abc' }

  class Error < StandardError
  end

  private
  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end
