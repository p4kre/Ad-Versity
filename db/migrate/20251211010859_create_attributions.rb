class CreateAttributions < ActiveRecord::Migration[8.1]
  def change
    create_table :attributions do |t|
      t.integer :contact_id, null: false
      t.integer :campaign_id, null: false
      t.string :event_type, null: false
      t.datetime :timestamp, null: false

      t.timestamps
    end
    
    add_index :attributions, :contact_id
    add_index :attributions, :campaign_id
    add_index :attributions, :event_type
    add_index :attributions, :timestamp
  end
end
