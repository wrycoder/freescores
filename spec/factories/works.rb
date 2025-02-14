FactoryBot.define do
  factory :work do
    composed_in { rand(1950..2024) }
    title { Cicero.words(rand(2..8)) }
  end
end
