# frozen_string_literal: true

class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy
end
