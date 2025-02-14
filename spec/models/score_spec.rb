require 'rails_helper'

RSpec.describe Score, type: :model do
  context "at creation" do
    it "has a work" do
      s = build(:score)
      expect(s.work.nil?).to be false
      s.work = nil
      expect(s.valid?).to be false
    end

    it "has the correct format" do
      s = build(:score, file_name: "basic.foo")
      expect(s.valid?).to be false
      expect(s.errors.messages).to_not be nil
      expect(s.errors.messages[:file_name][0])
        .to match(/must be in PDF/)
    end

    it "has a label" do
      s = build(:score, label: nil)
      expect(s.valid?).to be false
      expect(s.errors.messages[:label].empty?).to be false
    end
  end

  context "at runtime" do
  end
end
