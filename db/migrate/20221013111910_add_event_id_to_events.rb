class AddEventIdToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :event_id, :string
  end
end
