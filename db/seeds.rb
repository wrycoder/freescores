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
  ["oboe", 250, "woodwind"],
  ["English horn", 275, "woodwind"],
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
  ["alto", 20, "vocal"],
  ["tenor", 30, "vocal"],
  ["bass", 35, "vocal"],
  ["SATB choir", 40, "vocal ensemble"],
  ["SSAA choir", 45, "vocal ensemble"],
  ["TTBB choir", 50, "vocal ensemble"]
].each do |name, rank, family|
  Instrument.find_or_create_by!(
    name: name, rank: rank, family: family
  )
end
