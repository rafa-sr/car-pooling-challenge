# frozen_string_literal: true

put '/cars' do
  return status 400 unless params.present?
  return status 400 unless Car.valid_params? params

  Car.delete_previous_data
  Car.load_cars params

  status 200
end
