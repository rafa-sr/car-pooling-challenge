# frozen_string_literal: true

require 'spec_helper'

describe Group do
  describe '.valid?' do
    it 'return true when wating is boolean and 1 < people < 7' do
      subject = described_class.new(waiting: true, people: 1)

      expect(subject).to be_valid
    end

    it 'return false when people is not present' do
      subject = described_class.new(waiting: true)

      subject.valid?

      expect(subject.errors[:people]).to include('can\'t be blank')
    end

    it 'return false when people greater than 6' do
      subject = described_class.new(people: 7)

      subject.valid?

      expect(subject.errors[:people]).to include('must be less than 7')
    end

    it 'return false when people less than 1' do
      subject = described_class.new(people: 0)

      subject.valid?

      expect(subject.errors[:people]).to include('must be greater than 0')
    end
  end
end
