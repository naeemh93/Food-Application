# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contentful::RecipeService do
  subject { Contentful::RecipeService }

  describe '#public methods' do
    it 'returns true for public methods' do
      expect(subject.public_methods.include?(:call)).to eq true
    end
  end

  describe '.recipes_list' do
    context 'request is valid' do
      it 'returns correct response for recipes list' do
        response = subject.call(:recipes_list)
        expect(response.keys).to match_array %i[data status]
        expect(response[:status]).to eq(200)
      end

      it 'returns correct fields for recipes list' do
        response = subject.call(:recipes_list)
        expect(response[:data].first.keys).to match_array %i[title id image]
      end
    end

    context 'request is invalid' do
      before do
        allow(Contentful::RecipeList).to receive(:recipes_list).and_raise(ArgumentError, 'invalid request')
      end

      it 'returns 401 status' do
        response = subject.call(:recipes_list)
        expect(response[:status]).to eq 401
      end
    end
  end

  describe '.recipe_details' do
    let(:valid_id) { subject.call(:recipes_list)[:data].first.dig(:id) }

    context 'when resource is found' do
      it 'returns correct response for recipe' do
        response = subject.call(:recipe_details, valid_id)

        expect(response.keys).to match_array %i[data status]
        expect(response[:status]).to eq(200)
      end

      it 'returns correct fields for recipe' do
        response = subject.call(:recipe_details, valid_id)
        expect(response[:data].keys).to match_array %i[title image description chef_name tags_list]
      end
    end

    context 'resource is not found' do
      it 'returns error status' do
        response = subject.call(:recipe_details, 1)
        expect(response[:status]).to eq(404)
      end
    end

    context 'request is invalid' do
      before do
        allow(Contentful::RecipeList).to receive(:recipes_list).and_raise(ArgumentError, 'invalid request')
      end

      it 'returns 401 status' do
        response = subject.call(:recipe_details, valid_id)
        expect(response[:status]).to eq 401
      end
    end
  end
end
