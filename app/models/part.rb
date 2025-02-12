class Part < ApplicationRecord
  belongs_to  :work
  belongs_to  :instrument
  validates :quantity, numericality: { other_than: 0 }

  def instrument_rank
    instrument.rank
  end

  def written_for?(instrument_name)
    !(/#{instrument_name}/ =~ instrument.name).nil?
  end

  def <=>(other)
    instrument.rank <=> other.instrument.rank
  end
end
