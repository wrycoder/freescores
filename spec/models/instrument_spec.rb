require 'rails_helper'

RSpec.describe Instrument, type: :model do
  context "on creation" do
    it "has a name and family" do
      i = build(:instrument, name: nil, family: nil)
      expect(i.valid?).to be false
    end

    it "has a properly formatted title" do
      first_inst = create(:instrument, name: 'piccolo', rank: 350)
      second_inst = create(:instrument, name: 'violin', rank: 400)
      genre = create(:genre)
      w = build(:work, genre_id: genre.id)
      w.add_instruments({first_inst => 1, second_inst => 1})
      w.save!
      expect(w.to_s).to match(/#{first_inst.name}[, &]{1,2}#{second_inst.name}/)
    end
  end
end
