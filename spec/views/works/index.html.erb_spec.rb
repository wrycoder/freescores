require 'rails_helper'

RSpec.describe "works/index.html.erb", type: :view do
  before :each do
    create(:genre)
    create(:instrument)
    5.times do
      work = build(:work, genre: Genre.first)
      work.add_instruments({
        Instrument.first => 1
      })
      work.save!
    end
    assign(:works, Work.all)
    define_environment
    controller.extra_params = { original_url:
      "https://sowash.com/works?sort_key=genre_id&order=descending"
    }

  end

  after :each do
    clear_environment
  end

  it "has controls for searching and sorting" do
    render
    expect(rendered).to match(/#{Work.first.title}/)
    page = Nokogiri::HTML(rendered)
    scope_selector = page.css('.scope-selector')
    expect(scope_selector.nil?).to be false
    search_term_selector = page.css('.search-term-selector')
    expect(scope_selector.nil?).to be false
  end

end
