class Work < ApplicationRecord
  has_many  :parts, dependent: :destroy
  accepts_nested_attributes_for :parts
  belongs_to :genre
  validates :composed_in, presence: true
  validates :title, presence: true
  validates :score_link, presence: true
  validates :genre_id, presence: true
  validates_presence_of  :parts, on: :create
  validates :lyricist, presence: true,
        if: Proc.new { |w| !w.genre_id.nil? && w.genre.vocal? }

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

  def self.build_from_params(params)
    work = Work.new(
      title: params["title"],
      genre_id: params["genre_id"],
      score_link: params["score_link"],
      composed_in: params["composed_in"])
    if params.has_key?("revised_in")
      work.revised_in = params["revised_in"]
    end
    instruments = {}
    params["parts_attributes"].each do |p|
      if p[1]["instrument_id"] != ""
        key = Instrument.find(p[1]["instrument_id"])
        value = p[1]["quantity"].to_i
        instruments[key] = value
      end
    end
    work.add_instruments(instruments)
    work
  end
end
