class AddLikeCountToPhoto < ActiveRecord::Migration[7.0]
  def change
    add_column :photos, :like_count, :integer
  end
end
