require 'rails_helper'
include WorksHelper

describe WorksHelper, type: :helper do
  it "should format a list properly" do
    instruments = [
      [1, "violin", 300],
      [1, "cello", 320],
      [1, "piano", 400]
    ]
    expect(oxford_list(instruments))
        .to match(/violin, cello, and piano/)
    instruments = [[1, "piano", 480]]
    expect(oxford_list(instruments))
        .to match(/^piano$/)
  end

  it "should include the name of the lyricist" do
    song_genre = FactoryBot.create(:genre, name: "art song", vocal: true)
    kbd_genre = FactoryBot.create(:genre, name: "solo keyboard", vocal: false)
    singer = FactoryBot.create(:instrument, name: "soprano",
                          family: "vocal", rank: 10)
    piano = FactoryBot.create(:instrument, name: "piano",
                          family: "keyboard", rank: 540)
    song = build(:work, lyricist: "Walt Whitman",
                  genre_id: song_genre.id)
    song.add_instruments({ singer => 1, piano => 1 })
    song.save!
    sonata = build(:work, genre_id: kbd_genre.id)
    sonata.add_instruments({ piano => 1 })
    sonata.save!
    expect(formatted_title(song)).to match(/\(text by Walt Whitman\)/)
    expect(formatted_title(sonata)).to_not match(/\(text/)
  end

  it "should highlight the current sort_key column" do
    if !ENV['FILE_HOST'].nil?
      @original_file_host = ENV['FILE_HOST']
    else
      ENV['FILE_HOST'] = '3.139.72.192:8181'
      @original_file_host = nil
    end

    current_url = 'https://sowash.com/works?sort_key=title&order=ascending'
    result = sorted_column_headers(current_url)
    expect(result[:title][0]).to match(/Title⬆️/)
    expect(result[:genre_id][0]).to_not match(/[⬇️,⬆️]/)
    expect(result[:composed_in][0]).to_not match(/[⬇️,⬆️]/)
    current_url = 'https://sowash.com/works?sort_key=genre_id&order=descending'
    result = sorted_column_headers(current_url)
    expect(result[:genre_id][0]).to match(/Instrumentation⬇️/)
    expect(result[:composed_in][0]).to_not match(/[⬇️,⬆️]/)
    expect(result[:title][0]).to_not match(/[⬇️,⬆️]/)
    current_url = 'https://sowash.com/works'
    result = sorted_column_headers(current_url)
    expect(result[:composed_in][0]).to match(/Year⬆️/)
    expect(result[:title][0]).to_not match(/[⬇️,⬆️]/)
    expect(result[:genre_id][0]).to_not match(/[⬇️,⬆️]/)
    ENV['FILE_HOST'] = @original_file_host
  end

  it "should build a link from a hash of column header options" do
    if !ENV['APP_HOST'].nil?
      @original_app_host = ENV['APP_HOST']
    else
      ENV['APP_HOST'] = 'http://3.139.72.192:8181'
      @original_app_host = nil
    end
    current_url = 'https://sowash.com/works?sort_key=composed_in&order=descending'
    headers = sorted_column_headers(current_url)
    expect(header_link(headers[:title])).to match(
      /\/works\?sort_key=title&order=ascending/
    )
    expect(header_link(headers[:composed_in])).to match(
      /\/works\?sort_key=composed_in&order=ascending/
    )
    current_url = 'https://sowash.com/works?sort_key=composed_in&order=ascending'
    headers = sorted_column_headers(current_url)
    expect(header_link(headers[:composed_in])).to match(
      /\/works\?sort_key=composed_in&order=descending/
    )
    current_url = 'https://sowash.com/works?sort_key=genre_id&order=descending'
    headers = sorted_column_headers(current_url)
    expect(header_link(headers[:genre_id])).to match(
      /\/works\?sort_key=genre_id&order=ascending/
    )
    expect(header_link(headers[:title])).to match(
      /\/works\?sort_key=title&order=ascending/
    )
    ENV['APP_HOST'] = @original_app_host
  end
end
