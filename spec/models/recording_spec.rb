require 'rails_helper'

RSpec.describe Recording, type: :model do
  context "at creation" do
    it "has a work" do
      r = build(:recording)
      expect(r.work.nil?).to be false
      r.work = nil
      expect(r.valid?).to be false
    end

    it "has the correct format" do
      r = build(:recording, file_name: "foobar.foo")
      expect(r.valid?).to be false
      expect(r.errors.messages).to_not be nil
      expect(r.errors.messages[:file_name][0])
        .to match(/must be MP3/)
    end

    it "has a label" do
      r = build(:recording, label: nil)
      expect(r.valid?).to be false
      expect(r.errors.messages[:label].empty?).to be false
    end
  end
end
