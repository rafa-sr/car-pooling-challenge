# frozen_string_literal: true

class Car < ActiveRecord::Base
  has_many :journeys

  validates :seats, presence: true, numericality: { only_integer: true,
                                                    greater_than: 3,
                                                    less_than:    7 }

  validates :available_seats, presence: true, numericality: { only_integer: true,
                                                              greater_than: -1,
                                                              less_than:    7 }

  validates :id, presence: true

  scope :by_availability_seats,
        lambda { |people|
          where('available_seats >= ?', people).limit(1)
        }

  scope :by_ids,
        lambda { |ids|
          where('id  IN (?) ', ids)
        }

  def self.valid_params?(params)
    params['_json'].each do |json_car|
      id = json_car['id'].to_i
      seats = json_car['seats'].to_i
      car = Car.new(id: id, seats: seats, available_seats: seats)

      return false unless car.valid?
    end
    true
  end

  def self.delete_previous_data
    Car.delete_all
    Journey.delete_all
  end

  def self.load_cars(params)
    params['_json'].each do |json_car|
      id = json_car['id'].to_i
      seats = json_car['seats'].to_i
      car = Car.new(id: id, seats: seats, available_seats: seats)
      car.save
      JourneyService.start_journey(car)
    end
  end

  def book_seats(seats)
    available_seats = self.available_seats - seats
    update!(available_seats: available_seats)
  end

  def release_seats(seats)
    available_seats = self.available_seats + seats
    update!(available_seats: available_seats)
  end
end
