module WorksHelper
  def oxford_list(instruments, options = {})
    options[:separator] ||= ','
    options[:oxford_comma] ||= true
    result = ''
    instruments.each_with_index do |inst, x|
      if instruments.length > 1 && x == (instruments.length - 1)
        if instruments.length != 2 && options[:oxford_comma] == true
          result << ', and ' + inst[1]
        else
          result << ' and ' + inst[1]
        end
      else
        if x > 0
          result << ', '
        end
        result << inst[1]
      end
    end
    result
  end

  def formatted_title(work)
    if work.genre.vocal?
      return work.title + " (text by #{work.lyricist})"
    else
      return work.title
    end
  end

  def sorted_column_headers(url)
    headers = {
      :title => [
        "Title", "sort_key=title", "order=ascending"
      ],
      :composed_in => [
        "Year⬆️", "sort_key=composed_in", "order=descending"
      ],
      :genre_id => [
        "Instrumentation", "sort_key=genre_id", "order=ascending"
      ]
    }
    if !(/sort_key/ =~ url).nil?
      key_match = /sort_key=([^&]+)&/.match(url)
      if !key_match.nil?
        key = key_match[1]
        if !(/descending/ =~ url).nil?
          arrow = "⬇️"
          other_order = "ascending"
        else
          arrow = "⬆️ "
          other_order = "descending"
        end
        if key == "genre_id"
          headers[key.to_sym][0] = "Instrumentation" + arrow
          headers[:title][0] = "Title"
          headers[:composed_in][0] = "Year"
        elsif key == "composed_in"
          headers[key.to_sym][0] = "Year" + arrow
          headers[:genre_id][0] = "Instrumentation"
          headers[:title][0] = "Title"
        else
          headers[key.to_sym][0] = "Title" + arrow
          headers[:composed_in][0] = "Year"
          headers[:genre_id][0] = "Instrumentation"
        end
        headers[key.to_sym][2] = "order=" + other_order
      end
    end
    return headers
  end

  def header_link(header_keys)
    return ENV['APP_HOST'] + '/works?' + header_keys[1] + '&' + header_keys[2]
  end
end
