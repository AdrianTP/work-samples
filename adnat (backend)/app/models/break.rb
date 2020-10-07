class Break < ApplicationRecord
  belongs_to :shift

  validates :start, presence: true
  validates :finish, presence: true
  validates :length, presence: false # length field only exists for backwards-compatibility

  def duration
    (finish - start)/3600
  end
end
