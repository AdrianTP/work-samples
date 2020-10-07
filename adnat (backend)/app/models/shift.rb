class Shift < ApplicationRecord
  belongs_to :user

  validates :start, presence: true
  validates :finish, presence: true
  validates :break_length, presence: true, numericality: true #{ greater_than_or_equal_to: 0, less_than: (finish - start)/3600 }

  def duration
    (finish - start)/3600
  end

  def duration_without_break
    duration - break_length
  end
end
