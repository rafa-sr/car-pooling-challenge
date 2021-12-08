# frozen_string_literal: true

require 'spec_helper'

describe JourneyService do
  describe 'self.find' do
    context 'when possible in chronological'
    it 'return an Array of waiting groups orderer' do
      FactoryBot.create(:group, :not_waiting)
      FactoryBot.create_list(:group, 2)
      first_group = FactoryBot.create(:group, :first_group)
      first_waiting_group = described_class.find(first_group.people)

      expect(first_waiting_group.first.id).to eq first_group.id
    end
  end

  context 'when is not order possible in chronological order' do
    it 'return the next group that will fit the available seats' do
      FactoryBot.create(:group, :six_ppl)
      group_two = FactoryBot.create(:group, :first_group_four_ppl)
      # FactoryBot.create_list(:group, 99_999)
      FactoryBot.create_list(:group, 2)

      matched_group = described_class.find(group_two.people)

      expect(matched_group.first.id).to eq group_two.id
    end
  end

  describe 'self.star_journey' do
    context 'when is possible to fully fill a car' do
      it 'start a journey with the car' do
        car = FactoryBot.create(:car, :four_seats)
        FactoryBot.create_list(:group, 2)
        FactoryBot.create(:group, :first_group)
        new_journey = described_class.start_journey(car)

        expect(new_journey.car.id).to eq car.id
      end
    end

    context 'when given a group' do
      it 'start the journey if there is a car that fit group people' do
        car = FactoryBot.create(:car, :four_seats)
        FactoryBot.create_list(:group, 2)
        group = FactoryBot.create(:group, :four_ppl)
        new_journey = described_class.start_journey(car, group: group)

        expect(new_journey.car.id).to eq car.id
      end

      it 'does not start the journey if there is not cars that fit group people' do
        car = FactoryBot.create(:car, :four_seats)
        FactoryBot.create_list(:group, 2)
        group = FactoryBot.create(:group, :five_ppl)

        expect(described_class.start_journey(car, group: group)).to eq false
      end
    end
  end

  describe 'self.end_journey' do
    it 'delete the group' do
      journey = FactoryBot.create(:journey, :five_seats_full_book)
      size_before = Group.all.length
      described_class.end_journey(journey.group)

      expect(Group.all.length).to be size_before - 1
    end

    it 'release the seats of the current car' do
      journey = FactoryBot.create(:journey, :five_seats_full_book)
      car = journey.car
      described_class.end_journey(journey.group)

      expect(car.available_seats).to be car.seats
    end
  end
end
