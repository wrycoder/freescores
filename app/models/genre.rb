class Genre < ApplicationRecord
  has_many :works, dependent: :destroy
  validates :vocal, inclusion: [true, false]
  validates :name, presence: true, uniqueness: true
end
