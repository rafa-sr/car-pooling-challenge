# frozen_string_literal: true

class AddGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.integer :people
      t.boolean :waiting, default: true

      t.timestamps
    end
    add_index :groups, %i[waiting created_at], order: { created_at: :asc }
  end
end
