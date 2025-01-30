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
  end
end
