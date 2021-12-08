# frozen_string_literal: true

class AddCars < ActiveRecord::Migration[6.1]
  def change
    create_table :cars do |t|
      t.integer :seats
      t.integer :available_seats
    end

    add_index :cars, %i[available_seats]
  end
end
