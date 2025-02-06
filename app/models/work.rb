class Work < ApplicationRecord
  include ActionView::Helpers::UrlHelper
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

  def formatted_recording_link(options = {})
    options[:label] ||= "Recording"
    if ENV['FILE_HOST'].nil?
      raise RuntimeError.new("System misconfigured: no FILE_HOST defined")
    end
    if ENV['FILE_ROOT'].nil?
      raise RuntimeError.new("System misconfigured: no FILE_ROOT defined")
    end
    link_to(options[:label],
      "https://" + ENV['FILE_HOST'] + '/' + \
        ENV['FILE_ROOT'] + '/' + recording_link
    )
  end

  def formatted_score_link(options = {})
    options[:label] ||= "Score"
    if ENV['FILE_HOST'].nil?
      raise RuntimeError.new("System misconfigured: no FILE_HOST defined")
    end
    if ENV['FILE_ROOT'].nil?
      raise RuntimeError.new("System misconfigured: no FILE_ROOT defined")
    end
    link_to(options[:label],
      "https://" + ENV['FILE_HOST'] + '/' + \
        ENV['FILE_ROOT'] + '/' + score_link
    )
  end

  def self.build_from_params(params)
    work = Work.new(
      title: params["title"],
      genre_id: params["genre_id"],
      score_link: params["score_link"],
      recording_link: params["recording_link"],
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
