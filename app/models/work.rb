class Work < ApplicationRecord
  include ActionView::Helpers::UrlHelper
  has_many  :parts, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :recordings, dependent: :destroy
  accepts_nested_attributes_for :parts
  belongs_to :genre
  validates :composed_in, presence: true
  validates :title, presence: true
  validates :genre_id, presence: true
  validates_presence_of  :parts, on: :create
  validates :lyricist, presence: true,
        if: Proc.new { |w| !w.genre_id.nil? && w.genre.vocal? }

  scope :recorded, -> { Work.joins(:recordings) }
  scope :scored, -> { Work.joins(:scores) }
  scope :vocal, -> { Work.joins(:genre).where("vocal = true") }
  scope :instrumental, -> { Work.joins(:genre).where("vocal = false") }
  # The "solo" scope is a little misleading, because it
  # will also include any work written for a single ensemble...
  scope :solo, -> { Part.group(:work_id)
                        .having('count(*) = 1') }

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

  def <=>(other)
    parts.sort.first <=> other.parts.sort.first
  end

  def formatted_recording_links(options = {}, &block)
    if ENV['MEDIA_HOST'].nil?
      raise RuntimeError.new("System misconfigured: no MEDIA_HOST defined")
    end
    if ENV['FILE_ROOT'].nil?
      raise RuntimeError.new("System misconfigured: no FILE_ROOT defined")
    end
    recordings.each do |r|
      yield [r.id,
             link_to(r.label,
                ENV['MEDIA_HOST'] + '/' + \
                ENV['FILE_ROOT'] + '/' + r.file_name)]
    end
  end

  def formatted_score_links(options = {}, &block)
    if ENV['MEDIA_HOST'].nil?
      raise RuntimeError.new("System misconfigured: no MEDIA_HOST defined")
    end
    if ENV['FILE_ROOT'].nil?
      raise RuntimeError.new("System misconfigured: no FILE_ROOT defined")
    end
    scores.each do |s|
      yield [s.id,
             link_to(s.label,
                ENV['MEDIA_HOST'] + '/' + \
                ENV['FILE_ROOT'] + '/' + s.file_name)]
      end
  end

  def written_for?(instrument_name)
    parts.each do |p|
      if !(/#{instrument_name}/ =~ p.instrument.name).nil?
        return true
      end
    end
    return false
  end

  def self.build_from_params(params)
    work = Work.new(
      title: params["title"],
      genre_id: params["genre_id"],
      composed_in: params["composed_in"])
    if params.has_key?("revised_in")
      work.revised_in = params["revised_in"]
    end
    if params.has_key?("lyricist")
      work.lyricist = params["lyricist"]
    end
    if params.has_key?("ascap")
      work.ascap = params["ascap"]
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
