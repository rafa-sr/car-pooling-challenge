# frozen_string_literal: true

class Group < ActiveRecord::Base
  has_one :journey

  validates :people, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 7 }

  scope :by_waiting_and_ppl,
        lambda { |people|
          where('waiting = ? and people <= ?', true, people).order('created_at ASC').limit(1)
        }
end
