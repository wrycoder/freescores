module ApplicationHelper
  # Returns a context-sensitive title
  def app_title(page_title = '')
    base_title = "Rick Sowash"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def composer_menu_prompts(key)
    prompts = {
      :books        => [
        "https://sowash.com/graphics/menu/menu3a.gif",
        "https://sowash.com/books/index.html"],
      :cds          => [
        "https://sowash.com/graphics/menu/menu1a.gif",
        "https://sowash.com/recordings/index.html"],
      :sheetmusic   => [
        "https://sowash.com/graphics/menu/menu2a.gif",
        "https://sowash.blurve.net"],
      :filmscores   => [
        "https://sowash.com/graphics/menu/menu9a.gif",
        "https://sowash.com/filmscore/index.html"],
      :contact      => [
        "https://sowash.com/graphics/menu/menu6a.gif",
        "https://sowash.com/author/contact.html"],
      :home         => [
        "https://sowash.com/graphics/menu/menu7a.gif",
        "https://sowash.com/index.html"]
    }
    return prompts[key]
  end
end
