# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contentful::RecipeService do
  subject { Contentful::RecipeService.new }

  describe '#public methods' do
    it 'returns true for public methods' do
      expect(subject.public_methods.include?(:perform)).to eq true
    end

    it 'returns false for private methods' do
      expect(subject.public_methods.include?(:recipe_details)).to eq false
      expect(subject.public_methods.include?(:recipes_list)).to eq false
    end
  end

  describe '#perform recipes_list' do
    context 'request is valid' do
      it 'returns correct response for recipes list' do
        response = subject.perform(:recipes_list)
        expect(response.keys).to match_array %i[data status]
        expect(response[:status]).to eq(200)
      end

      it 'returns correct fields for recipes list' do
        response = subject.perform(:recipes_list)
        expect(response[:data].first.keys).to match_array %i[title id image]
      end
    end

    context 'request is invalid' do
      before do
        subject.stub(:recipes_list) { raise ArgumentError, 'invalid request' }
      end

      it 'returns 401 status' do
        response = subject.perform(:recipes_list)
        expect(response[:status]).to eq 401
      end
    end
  end
end
