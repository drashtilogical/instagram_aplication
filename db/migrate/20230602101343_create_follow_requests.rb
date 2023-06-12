# frozen_string_literal: true

# Migration to create folowrequest table
class CreateFollowRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :follow_requests do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
