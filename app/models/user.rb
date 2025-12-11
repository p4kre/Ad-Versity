class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  before_save :downcase_email

  private

  def downcase_email
    email.downcase! if email.present?
  end
end
