require 'rails_helper'

RSpec.describe Score, type: :model do
  context "at creation" do
    it "has a work" do
      s = build(:score)
      expect(s.work.nil?).to be false
      s.work = nil
      expect(s.valid?).to be false
    end
  end

  context "at runtime" do
  end
end
