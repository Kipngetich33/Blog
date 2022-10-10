class AddCreatorToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :creator, :string
  end
end
