# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.string :code, null: false
      t.integer :guest_id, null: false

      t.datetime :start_date
      t.datetime :end_date

      t.integer :nights, null: false
      t.integer :guests, null: false
      t.integer :adults, null: false
      t.integer :children, null: false, default: 0
      t.integer :infants, null: false, default: 0

      t.string :status, null: false
      t.string :currency, null: false
      t.string :payout_price, null: false
      t.string :security_price, null: false
      t.string :total_price, null: false

      t.timestamps

      t.index :code, unique: true
    end

    add_foreign_key :reservations, :guests
  end
end
