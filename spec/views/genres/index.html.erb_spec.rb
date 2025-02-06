require 'rails_helper'

RSpec.describe "genres/index.html.erb", type: :view do
  it "shows all existing genres" do
    Genre.destroy_all
    5.times do
      create(:genre, name: Cicero.words(3))
    end
    assign(:genres, Genre.all)
    render
    expect(rendered).to match(/#{Genre.first.name}/)
    Genre.destroy_all
  end
end
