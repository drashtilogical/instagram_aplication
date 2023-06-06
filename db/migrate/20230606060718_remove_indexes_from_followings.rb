class RemoveIndexesFromFollowings < ActiveRecord::Migration[7.0]
  def change
    remove_index :followings, name: "index_followings_on_followed_user_id"
    remove_index :followings, name: "index_followings_on_follower_id"
  end
end
