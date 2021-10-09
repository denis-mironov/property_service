require 'rails_helper'

RSpec.describe Properties::FindClosestPropertiesService do
  subject { described_class.new(params).call }

  let(:params) do
    {lat: '52.5342963', lng: '13.4236807', property_type: 'apartment', marketing_type: 'sell'}
  end

  let!(:properties_within_5_km) { create_list(:property, 5, :within_5_km) }
  let!(:properties_beyond_5_km) { create_list(:property, 3, :beyond_5_km) }
  let!(:properties_for_rent) { create_list(:property, 2, :properties_for_rent, :within_5_km) }

  context 'when properties within 5 km exist' do
    it 'returns properties' do
      expect(subject.ids).to match_array(properties_within_5_km.map(&:id))
    end
  end

  context 'when properties within 5 km not exist' do
    let(:params) do
      {lat: '53.5342963', lng: '14.4236807', property_type: 'apartment', marketing_type: 'sell'}
    end

    it { is_expected.to be_empty }
  end
end
