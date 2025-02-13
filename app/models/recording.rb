class Recording < ApplicationRecord
  belongs_to :work
  validates_presence_of :label
  validates :file_name,
    presence: true,
    format: { with: /\.mp3\z/,
      message: 'must be MP3' }
end
