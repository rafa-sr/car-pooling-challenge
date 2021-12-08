# frozen_string_literal: true

require 'spec_helper'

describe Car do
  describe '.valid?' do
    context 'when #seats' do
      it 'is not presnet return false' do
        car = described_class.new

        car.valid?

        expect(car.errors[:seats]).to include('can\'t be blank')
      end

      it 'is not an integer return false' do
        car = described_class.new(seats: 'one')

        car.valid?

        expect(car.errors[:seats]).to include('is not a number')
      end

      it 'is less than 4 return false' do
        car = described_class.new(seats: 3)

        car.valid?

        expect(car.errors[:seats]).to include('must be greater than 3')
      end

      it 'is greater than 6 return false' do
        car = described_class.new(seats: 7)

        car.valid?

        expect(car.errors[:seats]).to include('must be less than 7')
      end
    end

    context 'when #available_seats' do
      it 'is not present return false' do
        car = described_class.new

        car.valid?

        expect(car.errors[:available_seats]).to include('can\'t be blank')
      end

      it 'is not an integer return false' do
        car = described_class.new(available_seats: 'one')

        car.valid?

        expect(car.errors[:available_seats]).to include('is not a number')
      end

      it 'is less than 0 return false' do
        car = described_class.new(available_seats: -1)

        car.valid?

        expect(car.errors[:available_seats]).to include('must be greater than -1')
      end

      it 'is greater than 6 return false' do
        car = described_class.new(available_seats: 7)

        car.valid?

        expect(car.errors[:available_seats]).to include('must be less than 7')
      end
    end

    it 'return false when #id is not present' do
      car = described_class.new

      car.valid?

      expect(car.errors[:id]).to include('can\'t be blank')
    end

    it 'return false when #id is not an integer' do
      car = described_class.new(id: 'one')

      car.valid?

      expect(car.errors[:seats]).to include('is not a number')
    end
  end

  describe '.release_seats' do
    let(:car) { described_class.create(seats: 6) }

    it 'increase the seats availability to (current seats + people leaving)' do
      car = described_class.create(seats: 5, id: 1, available_seats: 0)
      car.save
      car.release_seats(5)

      expect(car.available_seats).to eq 5
    end
  end

  describe '.book_seats' do
    it 'decrease the seats availability to (current seats - people entering)' do
      car = described_class.create(seats: 5, id: 1, available_seats: 5)
      car.save
      car.book_seats(5)

      expect(car.available_seats).to eq 0
    end
  end
end
