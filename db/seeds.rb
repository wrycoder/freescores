# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[["Trio",false],["Symphony",false],["String Quartet",false],
 ["Sonata",false],["Part Song",true], ["Hymn",true]].each do |name, vocal|
  Genre.find_or_create_by!(name: name, vocal: vocal)
end

[
  ["piccolo", 200, "woodwind"],
  ["flute", 210, "woodwind"],
  ["recorder", 225, "woodwind"],
  ["oboe", 250, "woodwind"],
  ["English horn", 275, "woodwind"],
  ["clarinet", 280, "woodwind"],
  ["bassoon", 300, "woodwind"],
  ["contrabassoon", 310, "woodwind"],
  ["trumpet", 410, "brass"],
  ["horn", 415, "brass"],
  ["flugelhorn", 417, "brass"],
  ["trombone", 420, "brass"],
  ["tuba", 440, "brass"],
  ["violin", 475, "strings"],
  ["viola", 480, "strings"],
  ["cello", 490, "strings"],
  ["double bass", 500, "strings"],
  ["soprano", 10, "vocal"],
  ["mezzo-soprano", 14, "vocal"],
  ["alto", 20, "vocal"],
  ["tenor", 30, "vocal"],
  ["baritone", 32, "vocal"],
  ["bass", 35, "vocal"],
  ["piano", 510, "keyboard"],
  ["harpsichord", 515, "keyboard"],
  ["woodwind ensemble", 520, "instrumental ensemble"],
  ["brass quintet", 525, "instrumental ensemble"],
  ["string trio", 550, "instrumental ensemble"],
  ["string ensemble", 555, "instrumental ensemble"],
  ["string quartet", 560, "instrumental ensemble"],
  ["chamber orchestra", 570, "instrumental ensemble"],
  ["orchestra", 580, "instrumental ensemble"],
  ["SATB choir", 40, "vocal ensemble"],
  ["SSATB choir", 41, "vocal ensemble"],
  ["STB choir", 42, "vocal ensemble"],
  ["SAB choir", 44, "vocal ensemble"],
  ["SSAA choir", 45, "vocal ensemble"],
  ["TTBB choir", 50, "vocal ensemble"],
  ["mixed voice choir", 51, "vocal ensemble"]
].each do |name, rank, family|
  Instrument.find_or_create_by!(
    name: name, rank: rank, family: family
  )
end
