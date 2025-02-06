class LinerNote < ApplicationRecord
  belongs_to  :work
  validates :note, presence: true, length: { minimum: 3 }
end
