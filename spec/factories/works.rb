FactoryBot.define do
  factory :work do
    composed_in { rand(1950..2024) }
    title { Cicero.words(rand(2..8)) }
    score_link { 'https://' + Cicero.words(1) +
                  '.' + Cicero.words(1) + '.com/' +
                  Cicero.words(1) + '.pdf' } 
  end
end
