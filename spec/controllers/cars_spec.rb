# frozen_string_literal: true

describe 'cars' do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json'
    }
  end

  describe '#PUT create' do
    let(:valid_params) do
      [
        {
          id:    1,
          seats: 4
        },
        {
          id:    2,
          seats: 6
        }
      ]
    end

    let(:invalid_params) do
      [
        {
          id:    1,
          seats: 4
        },
        {
          id:    2,
          seats: 7
        }
      ]
    end

    it 'returns 200 when cars are created' do
      put '/cars',
          valid_params.to_json,
          headers

      expect(last_response.status).to be 200
    end

    it 'load the cars from the json array' do
      params_array_ids = []
      params_array_ids.append(valid_params[0][:id])
      params_array_ids.append(valid_params[1][:id])

      put '/cars',
          valid_params.to_json,
          headers

      car_array_ids = Car.all.ids
      expect(car_array_ids).to eq params_array_ids
    end

    context 'with errors' do
      it 'return status 400 when no params' do
        put '/cars', {}, headers

        expect(last_response.status).to be 400
      end

      it 'return status 400 when no valid params' do
        put '/cars', invalid_params.to_json,
            headers

        expect(last_response.status).to be 400
      end
    end

    it 'remove all the previous cars' do
      FactoryBot.create_list(:car, 4)

      put '/cars', valid_params.to_json, headers

      expect(Car.all.length).to eq valid_params.length
    end

    it 'remove all the previous journeys' do
      FactoryBot.create_list(:journey, 2)

      put '/cars', valid_params.to_json, headers

      expect(Journey.all.length).to eq 0
    end

    it 'start journeys if there are waiting groups' do
      FactoryBot.create_list(:group, 2, :four_ppl)

      put '/cars',
          valid_params.to_json,
          headers

      expect(Journey.all.length).to eq 2
    end
  end
end
