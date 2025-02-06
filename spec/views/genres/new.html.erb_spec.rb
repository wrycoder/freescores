require 'rails_helper'

RSpec.describe "genres/new.html.erb", type: :view do
  it "shows a new prospective genre" do
    assign(:genre, build(:genre, name: "", vocal: nil))
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Vocal/)
  end
end
