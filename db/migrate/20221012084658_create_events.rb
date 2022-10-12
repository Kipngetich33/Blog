class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :email
      t.string :event
      t.string :sg_event_id
      t.string :sg_message_id
      t.string :ip
      t.string :response
      t.string :smtp_id
      t.integer :timestamp
      t.integer :tls
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
