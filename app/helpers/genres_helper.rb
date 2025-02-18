module GenresHelper
  def total_for_genre(genre_id)
    Work.joins(:genre)
        .where("works.genre_id = genres.id "\
               " and genres.id = ?", genre_id)
        .count
  end
end
