# frozen_string_literal: true

module GuestServices
  # Service to list all guests
  class List < ApplicationService
    def perform
      Guest.all
    end
  end
end
