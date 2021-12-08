# frozen_string_literal: true

require 'spec_helper'

describe 'journeys' do
  describe '#POST' do
    describe '/journey' do
      let(:headers) do
        {
          'CONTENT_TYPE' => 'application/json'
        }
      end

      let(:valid_params) do
        {
          id:     1,
          people: 4
        }
      end

      it 'respond 200 ok when group is registered correctly' do
        FactoryBot.create(:car)
        post '/journey', valid_params.to_json, headers

        expect(last_response.status).to be 200
      end

      it 'put group.waiting to true when there not available cars' do
        car = FactoryBot.create(:car)
        car.book_seats(car.seats)

        post '/journey', valid_params.to_json, headers

        group = Group.find(valid_params[:id])
        expect(group.waiting).to be true
      end

      it 'put group.waiting to false when the journey start' do
        FactoryBot.create(:car)

        post '/journey', valid_params.to_json, headers

        group = Group.find(valid_params[:id])
        expect(group.waiting).to be false
      end

      it 'updated available_seats when group is registered correctly' do
        car = FactoryBot.create(:car)
        updated_seats = car.seats - valid_params[:people]

        post '/journey', valid_params.to_json, headers
        car.reload
        expect(car.available_seats).to eq updated_seats
      end
    end

    describe '/locate' do
      let(:headers) do
        {
          'CONTENT_TYPE' => 'application/x-www-form-urlencoded'
        }
      end

      it 'return 200 when there is car assigned' do
        journey = FactoryBot.create(:journey)

        post '/locate', { ID: journey.group_id }, headers

        expect(last_response.status).to be 200
      end

      it 'return the car id when there is car assigned' do
        journey = FactoryBot.create(:journey)

        post '/locate', { ID: journey.group_id }, headers

        resp = MultiJson.load(last_response.body)
        expect(resp['id']).to eq journey.car_id
      end

      it 'return the car seats when there is car assigned' do
        journey = FactoryBot.create(:journey)

        post '/locate', { ID: journey.group_id }, headers
        resp = MultiJson.load(last_response.body)
        expect(resp['seats']).to eq journey.car.seats
      end

      it 'return 404 when there is no group to be found' do
        post '/locate', { ID: 999 }, headers

        expect(last_response.status).to be 404
      end

      it 'return 204 when the group is waiting to be assigned to a car' do
        group = FactoryBot.create(:group)

        post '/locate', { ID: group.id }, headers

        expect(last_response.status).to be 204
      end
    end

    describe '/dropoff' do
      let(:headers) do
        {
          'CONTENT_TYPE' => 'application/x-www-form-urlencoded'
        }
      end

      context 'when the group is unregistered correctly' do
        it 'return 204 if not car assigned' do
          group = FactoryBot.create(:group)

          post "/dropoff?ID=#{group.id}", headers

          expect(last_response.status).to be 204
        end

        it 'delete the group' do
          journey = FactoryBot.create(:journey, :five_seats_full_book)
          init_length = Group.all.length

          post "/dropoff?ID=#{journey.group_id}", headers

          expect(Group.all.length).to eq init_length - 1
        end

        it 'return 200 if car is assigned' do
          journey = FactoryBot.create(:journey, :five_seats_full_book)

          post "/dropoff?ID=#{journey.group_id}", headers

          expect(last_response.status).to be 200
        end

        it 'release the car seats' do
          journey = FactoryBot.create(:journey, :six_seats_full_book)

          post "/dropoff?ID=#{journey.group_id}", headers

          journey.car.reload
          expect(journey.car.available_seats).to be journey.car.seats
        end

        it 'takes a look on the waiting group and try to assign this car' do
          journey = FactoryBot.create(:journey, :six_seats_full_book)
          first_journey_car = journey.car
          group = FactoryBot.create(:group, :first_group_six_ppl)
          FactoryBot.create(:group, :five_ppl)
          FactoryBot.create(:group, :one_ppl)

          post "/dropoff?ID=#{journey.group_id}", headers

          group.reload
          expect(group.journey.car.id).to be first_journey_car.id
        end
      end

      it 'return status 404 when the group is not found' do
        post '/dropoff', { ID: 999_999 }, headers

        expect(last_response.status).to be 404
      end

      it 'return status 400 when there is a failure on the format' do
        group = FactoryBot.create(:group)

        post "/dropoff?ids=#{group.id}", headers

        expect(last_response.status).to be 400
      end
    end
  end
end
