namespace :sowash do
  desc "Import TSV data"
  task :load, [:filename] =>:environment do |task, args|
    puts "Loading data from #{args[:filename]}"
    rawdata = IO.readlines(args[:filename])
    work = nil
    rawdata.each_with_index do |line, index|
      fields = line.split("\t")
      if index == 0 || fields[0] != work.title
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

    rawdata.each_with_index do |line, index|
      fields = line.split("\t")
      work = Work.find_by_title(fields[0])
      if !fields[5].nil?
        if !(/\.mp3/ =~ fields[5]).nil?
          recording = work.recordings
                      .find_or_initialize_by(
            label: fields[4],
            file_name: fields[5].sub(/\r\n$/, ''))
          if !recording.valid?
            puts "Unable to add recording"
            puts recording.errors.messages
          else
            recording.save!
          end
        elsif !(/\.pdf/ =~ fields[5]).nil?
          score = work.scores
                      .find_or_initialize_by(
            label: fields[4],
            file_name: fields[5].sub(/\r\n$/, ''))
          if !score.valid?
            puts "Unable to add score"
            puts score.errors.messages
          else
            score.save!
          end
        end
      end # !fields[5].nil?
    end
  end
end
