require 'rails_helper'

RSpec.describe LinerNote, type: :model do
  before :each do
    @genre = create(:genre)
    @work = build(:work, genre_id: @genre.id)
    @instrument = create(:instrument)
    @work.add_instruments({ @instrument => 1 })
    @work.save!
  end

  after :each do
    Work.destroy_all
    Instrument.destroy_all
    Genre.destroy_all
  end

  context "on creation" do
    it "should have a work" do
      ln = build(:liner_note)
      expect(ln.valid?).to be false
      ln.work = @work
      expect { ln.save! }.to_not raise_error
    end

    it "should not be empty" do
      ln = build(:liner_note,
        work: @work, note: nil)
      expect(ln.valid?).to be false
      ln.note = Cicero.words(50)
      expect { ln.save! }.to_not raise_error
    end
  end
end
