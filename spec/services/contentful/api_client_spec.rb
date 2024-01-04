# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contentful::ApiClient do
  describe '.public_methods' do
    it 'includes the connection method' do
      expect(described_class.public_methods).to include(:connection)
    end
  end

  describe '.connection' do
    context 'when connection is successful' do
      it 'returns a client object with configurations' do
        client = described_class.connection
        expect(client.configuration.present?).to be_truthy
      end
    end

    context 'when connection is unsuccessful' do
      before do
        ENV['SPACE_KEY'] = 'random'
      end

      it 'raises Contentful::NotFound error' do
        expect { described_class.connection }.to raise_error(Contentful::NotFound)
      end
    end
  end
end
