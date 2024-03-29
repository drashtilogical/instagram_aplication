# frozen_string_literal: true

# Migration to create like table
class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :photo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
