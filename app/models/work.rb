class Work < ApplicationRecord
  has_many  :parts, dependent: :destroy
  belongs_to :genre
  validates :composed_in, presence: true
  validates :title, presence: true
  validates :score_link, presence: true
  validates_presence_of  :parts, on: :create

  def to_s
    result = title + ' ('
    list_instruments.each_with_index do |member, index|
      if index > 0
        result += ', '
      end
      result += member[1]
    end
    result += ')'
    result
  end

  def add_instruments(params)
    params.keys.each do |instrument|
      p = parts.new
      p.instrument = instrument
      p.quantity = params[instrument]
    end
  end

  def list_instruments
    ensemble = []
    parts.each do |part|
      entry = []
      if part.quantity == 1
        entry << ""
      else
        entry << part.quantity
      end
      entry << part.instrument.name.pluralize(part.quantity)
      entry << part.instrument.rank
      ensemble << entry
    end
    ensemble.sort { |a,b| a[2] <=> b[2] }
  end
end
