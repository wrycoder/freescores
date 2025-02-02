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

end
