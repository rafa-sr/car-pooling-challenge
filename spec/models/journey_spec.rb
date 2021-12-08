# frozen_string_literal: true

require 'spec_helper'

describe Journey do
  describe '.valid?' do
    it 'true if group_id, car_id are valid' do
      journey = described_class.new(group_id: 1, car_id: 1)

      expect(journey).to be_valid
    end

    it 'false if car_id is missing' do
      journey = described_class.new(group_id: 1)

      journey.valid?

      expect(journey.errors[:car_id]).to include('can\'t be blank')
    end

    it 'false if group_id is missing' do
      journey = described_class.new(car_id: 1)

      journey.valid?

      expect(journey.errors[:group_id]).to include('can\'t be blank')
    end

    it 'false if group_id is not an integer' do
      journey = described_class.new(group_id: 'one')

      journey.valid?

      expect(journey.errors[:group_id]).to include('is not a number')
    end

    it 'false if car_id is not an integer' do
      journey = described_class.new(car_id: 'one')

      journey.valid?

      expect(journey.errors[:group_id]).to include('is not a number')
    end
  end
end
