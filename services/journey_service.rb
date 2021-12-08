# frozen_string_literal: true

class JourneyService
  def self.find(people)
    Group.by_waiting_and_ppl(people)
  end

  def self.start_journey(car, group: nil)
    if group.nil?
      matched_group_array = Group.by_waiting_and_ppl(car.available_seats)
      return false if matched_group_array.empty?

      matched_group = matched_group_array.first
    else
      matched_group = group
    end

    return false if invalid_group?(car, matched_group)

    journey = Journey.create(car_id: car.id, group_id: matched_group.id)
    car.book_seats(matched_group.people)
    journey
  end

  def self.invalid_group?(car, group)
    return true if group.people > car.available_seats

    false
  end

  def self.valid_params?(request)
    params = request.params
    path = request.env['PATH_INFO']

    return false if path == '/journey' && !(params['id'].present? && params['people'].present?)

    return false if ['/locate', '/dropoff'].include?(path) && !params['ID'].present?

    true
  end

  def self.end_journey(group)
    car = group.journey.car
    car.release_seats(group.people)
    group.delete
  end
end
