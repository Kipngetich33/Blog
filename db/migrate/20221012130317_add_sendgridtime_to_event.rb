class AddSendgridtimeToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :sendgridtime, :integer
  end
end
