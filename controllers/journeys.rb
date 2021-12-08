# frozen_string_literal: true

post '/journey', allows: %i[id people] do
  return status 400 unless JourneyService.valid_params?(request)

  group = Group.new(id: params[:id], people: params[:people])
  return status 400 unless group.save

  car_array = Car.by_availability_seats(group.people)
  return status 202 if car_array.empty?

  car = car_array.first
  journey = JourneyService.start_journey(car, group: group)
  return status 200 if journey

  status 400
end

post '/dropoff', allows: :ID do
  return status 400 unless JourneyService.valid_params?(request)

  group = Group.find(params[:ID])
  if group.waiting?
    group.delete
    return status 204
  else
    JourneyService.end_journey(group)
    journey = JourneyService.start_journey(group.journey.car)

    return journey.to_json if journey
  end
  status 200
end

post '/locate', allows: :ID do
  return status 400 unless JourneyService.valid_params?(request)

  group = Group.find(params[:ID])

  return status 204 if group.waiting?

  car = Car.find(group.journey.car_id)

  return car.to_json if car

  status 400
end
