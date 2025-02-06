FactoryBot.define do
  factory :liner_note do
    note { Cicero.words(50) }
  end
end
