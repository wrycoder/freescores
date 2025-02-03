require 'rails_helper'

RSpec.describe "dashboard/show.html.erb", type: :view do
  it "shows a working interface" do
    render
    expect(rendered).to match(/Add a new work/)
    expect(rendered).to match(/Add a genre/)
    expect(rendered).to match(/Add an instrument/)
  end
end
