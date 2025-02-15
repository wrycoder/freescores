namespace :sowash do

  current_line = nil
  file_label_index = nil
  file_name_index = nil

  desc "Handle MP3 and PDF files for a given work"
  task :process_files => :environment do |task, args|
    fields = current_line.split("\t")
    work = Work.find_by_title(fields[0])
    if !fields[file_name_index].nil?
      if !(/\.mp3/ =~ fields[file_name_index]).nil?
        recording = work.recordings
                    .find_or_initialize_by(
          label: fields[file_label_index],
          file_name: fields[file_name_index].sub(/\r\n$/, ''))
        if !recording.valid?
          puts "Unable to add recording"
          puts recording.errors.messages
        else
          recording.save!
        end
      elsif !(/\.pdf/ =~ fields[file_name_index]).nil?
        score = work.scores
                    .find_or_initialize_by(
          label: fields[file_label_index],
          file_name: fields[file_name_index].sub(/\r\n$/, ''))
        if !score.valid?
          puts "Unable to add score"
          puts score.errors.messages
        else
          score.save!
        end
      end
    end # !fields[5].nil?
  end

  desc "Import TSV data for instrumental works"
  task :load_instrumental, [:filename] =>:environment do |task, args|
    puts "Loading instrumental works from #{args[:filename]}"
    rawdata = IO.readlines(args[:filename])
    work = nil
    rawdata.each_with_index do |line, index|
      if index == 0
        next # Skip labels on first line
      end
      fields = line.split("\t")
      if index == 1 || fields[0] != work.title
        genre_id = Genre.find_by_name(fields[2]).id
        work = Work.find_or_initialize_by(
          title: fields[0],
          composed_in: fields[1],
          genre_id: genre_id,
          ascap: true)
        fields[3].sub!(/^"/, '')
        fields[3].sub!(/"$/, '')
        forces = fields[3].split(",")
        forces.map {|s| s.strip!}
        instruments = {}
        forces.each do |f|
          instMatch = /([0-9]+ )*([a-zA-Z]+[ a-zA-Z]*)/.match(f)
          if !instMatch[1].nil?
            inst = Instrument.find_by_name(instMatch[2].singularize)
            instruments[inst] = instMatch[1].to_i
          else
            inst = Instrument.find_by_name(instMatch[2])
            instruments[inst] = 1
          end
        end
        work.add_instruments(instruments)
        if !work.valid?
          puts "Error on this record: #{fields.join(", ")}"
          puts work.errors.messages
          exit
        end
        work.save!
      end
    end
    file_label_index = 4
    file_name_index = 5
    rawdata.each_with_index do |line, index|
      current_line = line
      Rake::Task["sowash:process_files"].invoke
      Rake::Task["sowash:process_files"].reenable
    end
  end

  task :load_vocal, [:filename] =>:environment do |task, args|
    puts "Loading vocal works from #{args[:filename]}"
    rawdata = IO.readlines(args[:filename])
    work = nil
    rawdata.each_with_index do |line, index|
      if index == 0
        next # Skip labels on first line
      end
      fields = line.split("\t")
      if index == 1 || fields[0] != work.title
        genre_id = Genre.find_by_name(fields[6]).id
        work = Work.find_or_initialize_by(
          title: fields[0],
          composed_in: fields[1],
          genre_id: genre_id,
          lyricist: fields[3],
          ascap: true)
        if !fields[2].empty?
          work.revised_in = fields[2].to_i
        end
        fields[7].sub!(/^"/, '')
        fields[7].sub!(/"$/, '')
        forces = fields[7].split(",")
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
        if !work.valid?
          puts "Error on this record: #{fields.join(", ")}"
          puts work.errors.messages
          exit
        end
        work.save!
      end
    end
    file_label_index = 4
    file_name_index = 5
    rawdata.each_with_index do |line, index|
      current_line = line
      Rake::Task["sowash:process_files"].invoke
      Rake::Task["sowash:process_files"].reenable
    end
  end
end
