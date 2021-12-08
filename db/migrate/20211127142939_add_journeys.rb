# frozen_string_literal: true

class AddJourneys < ActiveRecord::Migration[6.1]
  def change
    create_table :journeys do |t|
      t.integer :car_id
      t.integer :group_id
    end
  end
end
