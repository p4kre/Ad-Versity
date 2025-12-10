class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :objective
      t.decimal :budget
      t.string :channel
      t.string :external_id

      t.timestamps
    end
  end
end
