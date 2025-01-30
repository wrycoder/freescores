require 'rails_helper'

RSpec.describe Genre, type: :model do
  context "on creation" do
    it "should have a name" do
      g = build(:genre, name: nil)
      expect(g.valid?).to be false
      g = build(:genre)
      expect(g.valid?).to be true
    end

    it "should be either vocal or non-vocal" do
      g = build(:genre, vocal: nil) 
      expect(g.valid?).to be false
      g = build(:genre)
      expect(g.valid?).to be true
    end
  end

  context "at runtime" do
    it "should be associated with one or more works" do
      genre = create(:genre)
      instrument = create(:instrument)
      work = build(:work, genre_id: genre.id)
      work.add_instruments({instrument => 1})
      expect(work.valid?).to be true
      work.save
      expect(genre.works.count).to eq(1)
    end
  end
end
