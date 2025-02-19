namespace :composer do
  column_defs = {
    :title          => -1,
    :composed_in    => -1,
    :revised_in     => -1,
    :lyricist       => -1,
    :label          => -1,
    :file_name      => -1,
    :genre          => -1,
    :forces         => -1
  }
  current_line = nil

  desc "Handle MP3 and PDF files for a given work"
  task :process_files => :environment do |task, args|
    fields = current_line.split("\t")
    title = fields[column_defs[:title]].gsub(/\A\"(.+)\"\z/, '\1')
    begin
      work = Work.find_by_title!(title)
    rescue ActiveRecord::RecordNotFound => rnfX
      raise "Unable to find this work: #{title}\n(rnfX.message)"
    end
    if !fields[column_defs[:file_name]].nil?
      if !(/\.mp3/ =~ fields[column_defs[:file_name]]).nil?
        recording = work.recordings
                    .find_or_initialize_by(
          label: fields[column_defs[:label]],
          file_name: fields[column_defs[:file_name]].sub(/\r\n$/, ''))
        if !recording.valid?
          puts "Unable to add recording"
          puts recording.errors.messages
        else
          recording.save!
        end
      elsif !(/\.pdf/ =~ fields[column_defs[:file_name]]).nil?
        score = work.scores
                  .find_or_initialize_by(
          label: fields[column_defs[:label]],
          file_name: fields[column_defs[:file_name]].sub(/\r\n$/, ''))
        if !score.valid?
          puts "Unable to add score"
          puts score.errors.messages
        else
          score.save!
        end
      end
    end
  end

  desc "Import data from a tab-separated txt file"
  task :load, [:filename] => :environment do |task, args|
    puts "Reading header in #{args[:filename]}"
    rawdata = IO.readlines(args[:filename])
    work = nil
    # MAIN LOOP
    rawdata.each_with_index do |line, line_index|
      if line_index == 0
        headers = line.split("\t")
        headers.each_with_index do |header, key_index|
          column_defs.keys.each do |key|
            if header.strip.to_sym == key
              column_defs[key] = key_index
            end
          end
        end
        next
      end
      column_defs.keys.each_with_index do |cdefkey, ci|
        if column_defs[cdefkey] < 0
          raise "Column definition missing for #{cdefkey}"
        end
      end
      fields = line.split("\t")
      if line_index == 1 || fields[column_defs[:title]] != work.title
        genre_id = Genre.find_by_name(fields[column_defs[:genre]]).id
        title = fields[column_defs[:title]].gsub(/\A\"(.+)\"\z/, '\1')
        work = Work.find_or_initialize_by(
          title: title,
          composed_in: fields[column_defs[:composed_in]],
          genre_id: genre_id,
          ascap: true)
        fields[column_defs[:forces]].sub!(/^"/, '')
        fields[column_defs[:forces]].sub!(/"$/, '')
        forces = fields[column_defs[:forces]].split(",")
        forces.map {|s| s.strip!}
        instruments = {}
        forces.each do |f|
          instMatch = /([0-9]+ )*([a-zA-Z\-]+[ a-zA-Z]*)/.match(f)
          if !instMatch[1].nil?
            inst = Instrument.find_by_name(instMatch[2].singularize)
            instruments[inst] = instMatch[1].to_i
          else
            inst = Instrument.find_by_name(instMatch[2])
            instruments[inst] = 1
          end
        end
        work.add_instruments(instruments)
        if work.genre.vocal?
          work.lyricist = fields[column_defs[:lyricist]]
        end
        if !work.valid?
          puts "Error on this record: #{fields.join(", ")}"
          puts work.errors.messages
          exit
        end
        work.save!
      end
    end # END MAIN LOOP
    rawdata.each_with_index do |line, index|
      if index == 0
        next
      end
      current_line = line
      Rake::Task["composer:process_files"].invoke
      Rake::Task["composer:process_files"].reenable
    end
  end
end
