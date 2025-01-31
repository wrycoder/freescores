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
end
