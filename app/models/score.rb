class Score < ApplicationRecord
  belongs_to :work
  validates_presence_of :label
  validates :file_name,
    presence: true,
    format: { with: /\.pdf\z/,
      message: 'must be in PDF' }
end
