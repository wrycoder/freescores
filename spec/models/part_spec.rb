require 'rails_helper'

RSpec.describe Part, type: :model do
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
end
