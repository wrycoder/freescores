require 'rails_helper'

RSpec.describe "genres/create.html.erb", type: :view do
  it "shows errors in draft genre" do
    create(:genre, name: "Poetry Slam")
    test_genre = build(:genre, name: "Poetry Slam")
    test_genre.valid?
    assign(:genre, test_genre)
    render
    expect(rendered).to match(/ame has already/)
    Genre.destroy_all
  end
end
