# frozen_string_literal: true

class Journey < ActiveRecord::Base
  after_create :update_group_waiting

  belongs_to :car
  belongs_to :group

  validates :group_id, presence: true, numericality: { only_integer: true }
  validates :car_id, presence: true, numericality: { only_integer: true }

  def update_group_waiting
    group.update(waiting: false)
  end
end
