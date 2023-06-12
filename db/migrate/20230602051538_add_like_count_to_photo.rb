# frozen_string_literal: true

# Migration to add like count in photo table
class AddLikeCountToPhoto < ActiveRecord::Migration[7.0]
  def change
    add_column :photos, :like_count, :integer
  end
end
