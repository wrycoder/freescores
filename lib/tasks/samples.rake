namespace :samples do
  desc "Load sample data"
  task :load => :environment do
    kbd_genre = FactoryBot.create(:genre, name: "solo keyboard", vocal: false)
    vocal_genre = FactoryBot.create(:genre, name: "art song", vocal: true)
    cbr_genre = FactoryBot.create(:genre, name: "small chamber", vocal:false)
    oboe = FactoryBot.create(:instrument,
                        name: "oboe",
                        family: "woodwinds",
                        rank: 280)
    trombone = FactoryBot.create(:instrument,
                        name: "trombone",
                        family: "brass",
                        rank: 400)
    piano = FactoryBot.create(:instrument,
                        name: "piano",
                        family: "keyboard",
                        rank: 700)
    soprano = FactoryBot.create(:instrument,
                        name: "soprano",
                        family: "vocal",
                        rank: 10)
    8.times do
      w = FactoryBot.build(:work, genre_id: kbd_genre.id)
      w.add_instruments({ piano => 1 })
      w.save!
    end
    4.times do
      w = FactoryBot.build(:work, genre_id: cbr_genre.id)
      w.add_instruments({ trombone => 1, oboe => 1,
                          piano => 1})
      w.save!
    end
    3.times do
      w = FactoryBot.build(:work, genre_id: vocal_genre.id, 
                lyricist: "Walt Whitman")
      w.add_instruments({ soprano => 1, piano => 1 }) 
      w.save!
    end
  end
end
