class RemoveIndexesFromFollowRequests < ActiveRecord::Migration[7.0]
  def change
    remove_index :follow_requests, name: "index_follow_requests_on_receiver_id"
    remove_index :follow_requests, name: "index_follow_requests_on_sender_id"
  end
end
