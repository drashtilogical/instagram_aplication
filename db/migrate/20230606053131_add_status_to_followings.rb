class AddStatusToFollowings < ActiveRecord::Migration[7.0]
  def change
    add_column :followings, :status, :string,default: 'pending'
  end
end

