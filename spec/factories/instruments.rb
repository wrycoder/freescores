FactoryBot.define do
  factory :instrument do
    names = [
      ["piccolo","woodwind", 100],
      ["flute","woodwind", 150],
      ["oboe","woodwind", 200],
      ["bassoon","woodwind", 250],
      ["horn","brass", 300],
      ["trumpet","brass", 350],
      ["trombone","brass", 400],
      ["tuba","brass", 450],
      ["violin","strings", 500],
      ["viola","strings", 550],
      ["cello","strings", 600],
      ["contrabass","strings", 650],
      ["piano","keyboard", 700],
      ["percussion","percussion", 750]
    ]
    index = Random.rand(0..(names.length-1))
    name { names[index][0] }
    rank { names[index][2] }
    family { names[index][1] }
  end
end
