require 'rails_helper'

RSpec.describe Part, type: :model do
  after :each do
    Work.destroy_all
    Instrument.destroy_all
    Genre.destroy_all
  end

  context "on creation" do
    it "belongs to a specific work and has a specific instrument" do
      expect { create(:part) }.to raise_error(ActiveRecord::RecordInvalid)
      genre = create(:genre)
      w = build(:work, genre_id: genre.id)
      p = build(:part, work_id: w.id)
      expect(p.valid?).to be false
      i = create(:instrument)
      w.add_instruments({i => 1})
      w.save!
      p = w.parts.first
      expect(p.valid?).to be true
    end

    it "has a quantity" do
      genre = create(:genre)
      initial_count = Work.count
      w = build(:work, genre_id: genre.id)
      i = create(:instrument)
      w.add_instruments({i => nil})
      expect { w.save! }.to raise_error(ActiveRecord::RecordInvalid)
      w.parts.first.update(quantity: 1)
      w.save!
      expect(Work.count).to eq(initial_count + 1)
    end
  end

  context "at runtime" do
    it "can be sorted based on instrument ranking" do
      genre = create(:genre)
      work_1 = build(:work, genre: genre)
      work_2 = build(:work, genre: genre)
      work_3 = build(:work, genre: genre)
      piano = create(:instrument, name: "piano", rank: 500)
      violin = create(:instrument, name: "violin", rank: 100)
      cello = create(:instrument, name: "cello", rank: 300)
      trumpet = create(:instrument, name: "trumpet", rank: 150)
      harmonica = create(:instrument, name: "harmonica", rank: 175)
      work_1.add_instruments({piano => 1, cello => 1, violin => 1})
      work_1.save!
      work_2.add_instruments({cello => 1, trumpet => 1, piano => 1})
      work_2.save!
      work_3.add_instruments({piano => 1, harmonica => 1, cello => 1})
      work_3.save!
      expect([piano, harmonica, trumpet].sort.first.name).to match(/trumpet/)
      expect([harmonica, cello, violin].sort.first.name).to match(/violin/)
      expect(work_2.parts.sort.first.instrument.name).to match(/trumpet/)
      expect(work_2.parts.sort.last.instrument.name).to match(/piano/)
      expect(work_3.parts.sort.first.instrument.name).to match(/harmonica/)
    end
  end
end
