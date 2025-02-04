class Part < ApplicationRecord
  belongs_to  :work
  belongs_to  :instrument
  validates :quantity, numericality: { other_than: 0 }
end
