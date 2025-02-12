require 'rails_helper'

RSpec.describe Recording, type: :model do
  context "at creation" do
    it "has a work" do
      r = build(:recording)
      expect(r.work.nil?).to be false
      r.work = nil
      expect(r.valid?).to be false
    end
  end

  context "at runtime" do
  end
end
