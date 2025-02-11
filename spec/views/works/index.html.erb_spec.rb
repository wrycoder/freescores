require 'rails_helper'

RSpec.describe "works/index.html.erb", type: :view do
  before :each do
    create(:genre)
    create(:instrument)
    5.times do
      work = build(:work,
        genre: Genre.first,
        recording_link: Cicero.words(1) + '.mp3')
      work.add_instruments({
        Instrument.first => 1
      })
      work.save!
    end
    assign(:works, Work.all)

    if !ENV['APP_HOST'].nil?
      @original_app_host = ENV['APP_HOST']
    else
      ENV['APP_HOST'] = 'http://ourserver.com'
      @original_app_host = nil
    end

    if !ENV['MEDIA_HOST'].nil?
      @original_media_host = ENV['MEDIA_HOST']
    else
      ENV['MEDIA_HOST'] = 'http://ourserver.com'
      @original_media_host = nil
    end

    if !ENV['FILE_ROOT'].nil?
      @original_file_root = ENV['FILE_ROOT']
    else
      ENV['FILE_ROOT'] = 'recordings/mp3'
      @original_file_root = nil
    end

    controller.extra_params = { original_url:
      "https://sowash.com/works?sort_key=genre_id&order=descending"
    }

  end

  after :each do
    ENV['APP_HOST'] = @original_app_host
    ENV['FILE_PATH'] = @original_file_path
    ENV['MEDIA_HOST'] = @original_media_host
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
