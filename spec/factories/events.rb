FactoryBot.define do
  factory :event do
    association :user

    title { "Party_#{rand(999)}" }
    address { "Moscow" }
    datetime { DateTime.now }
  end
end
