# frozen_string_literal: true

# Migration to add status in folowrequest table
class AddStatusToFollowRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :follow_requests, :status, :string, default: 'pending'
  end
end
