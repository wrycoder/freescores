require 'rails_helper'

RSpec.describe "genres/index.html.erb", type: :view do
  it "shows all existing genres" do
    Work.destroy_all
    Instrument.destroy_all
    Genre.destroy_all
    5.times do
      g = create(:genre, name: Cicero.words(3))
      i = create(:instrument, name: Cicero.words(2))
      w = build(:work, genre: g)
      w.add_instruments({ i => 1})
      w.save!
    end
    assign(:genres, Genre.all)
    render
    expect(rendered).to match(/#{Genre.first.name}/)
    Work.destroy_all
    Instrument.destroy_all
    Genre.destroy_all
  end
end
