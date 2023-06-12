# frozen_string_literal: true

# Migration to create photos table
class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.string :caption
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
