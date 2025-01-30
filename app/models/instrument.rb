class Instrument < ApplicationRecord
  has_many  :parts
  validates :name, presence: true
  validates :family, presence: true
end
