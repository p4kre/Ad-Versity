class CreateAudienceContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :audience_contacts do |t|
      t.references :audience, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
