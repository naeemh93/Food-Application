# frozen_string_literal: true

require 'rails_helper'

describe 'Contentful ApiClient' do
  subject { Contentful::ApiClient }

  describe '#public methods' do
    it 'validates connection method' do
      expect(subject.public_methods.include?(:connection)).to eq true
    end
  end

  describe '#connection' do
    context 'connection successfull' do
      it 'returns client object with configurations' do
        client = subject.connection
        expect(client.configuration.present?).to eq true
      end
    end

    context 'connection unsuccessfull' do
      before do
        ENV['SPACE_KEY'] = 'random'
      end

      it 'returns contentful not found error' do
        expect(subject.connection).to eql 'Contentful::NotFound'
      end
    end
  end
end
