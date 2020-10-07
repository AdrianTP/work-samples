class Organisation < ApplicationRecord
  has_many :organisations_user
  has_many :user, through: :organisations_user, dependent: :destroy

  validates :name, uniqueness: true, presence: :true
  validates :hourly_rate, presence: :true, numericality: true
end
