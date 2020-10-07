class User < ApplicationRecord
  has_many :organisations_user
  has_many :organisation, through: :organisations_user, dependent: :destroy
  has_many :shift, dependent: :destroy

  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email_address, uniqueness: true, presence: true
  validates :password_digest, presence: true, length: { minimum: 7 }
end
