# frozen_string_literal: true

# Migration to add status in following table
class AddStatusToFollowings < ActiveRecord::Migration[7.0]
  def change
    add_column :followings, :status, :string, default: 'pending'
  end
end
