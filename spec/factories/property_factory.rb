FactoryBot.define do
  factory :property do
    sequence(:id)
    zip_code { '10119' }
    city { 'Berlin' }
    offer_type { 'sell' }
    property_type { 'apartment' }

    trait :properties_for_rent do
      offer_type { 'rent' }
      property_type { 'single_family_house' }
    end

    trait :within_5_km do
      lng { rand(13.38..13.40).round(7) }
      lat { rand(52.51..52.52).round(7) }
    end

    trait :beyond_5_km do
      lng { rand(12.0..13.0).round(7) }
      lat { rand(50.0..51.0).round(7) }
    end
  end
end
