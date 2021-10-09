require 'rails_helper'

shared_examples 'validate missing params' do |key, message|
  context "when #{key} is missing" do
    let(:property_params) { params.except(key) }

    it 'returns an error' do
      expect(subject.errors.full_messages).to include(message)
    end
  end
end

shared_examples 'validate coordinates' do |key, value|
  context "when #{key} is #{value}" do
    let(:message) { key == :lat ? 'Latitude is invalid' : 'Longitude is invalid' }
    let(:property_params) { params.merge(key => value) }

    it 'returns an error' do
      expect(subject.errors.full_messages).to include(message)
    end
  end
end

shared_examples 'validate property information' do |key, value|
  context "when #{key} is #{value}" do
    let(:message) { key == :property_type ? 'Property type is invalid' : 'Marketing type is invalid' }
    let(:property_params) { params.merge(key => value) }

    it 'returns an error' do
      expect(subject.errors.full_messages).to include(message)
    end
  end
end

RSpec.describe PropertyParamsValidator do
  subject { described_class.new(property_params).validate }

  let(:params) do
    {lat: '52.5342963', lng: '13.4236807', property_type: 'apartment', marketing_type: 'sell'}
  end

  context 'when all params are valid' do
    let(:property_params) { params }

    it 'returns no errors' do
      expect(subject.errors.full_messages).to be_empty
    end
  end

  context 'when params are missing' do
    include_examples 'validate missing params', :lat, 'Latitude is required'
    include_examples 'validate missing params', :lng, 'Longitude is required'
    include_examples 'validate missing params', :property_type, 'Property type is required'
    include_examples 'validate missing params', :marketing_type, 'Marketing type is required'
  end

  context 'when params are invalid' do
    include_examples 'validate coordinates', :lat, '90.0000001'
    include_examples 'validate coordinates', :lat, '-90.0000001'
    include_examples 'validate coordinates', :lat, '52.123456a'
    include_examples 'validate coordinates', :lat, ' 52.1234567'
    include_examples 'validate coordinates', :lat, '52.1234567 '
    include_examples 'validate coordinates', :lat, '52. 1234567'
    include_examples 'validate coordinates', :lat, '52.'

    include_examples 'validate coordinates', :lng, '180.0000001'
    include_examples 'validate coordinates', :lng, '-180.0000001'
    include_examples 'validate coordinates', :lng, '52.123456a'
    include_examples 'validate coordinates', :lng, ' 52.1234567'
    include_examples 'validate coordinates', :lng, '52.1234567 '
    include_examples 'validate coordinates', :lng, '52. 1234567'
    include_examples 'validate coordinates', :lng, '52.'

    include_examples 'validate property information', :property_type, 'penthouse'
    include_examples 'validate property information', :marketing_type, 'show'
  end
end
