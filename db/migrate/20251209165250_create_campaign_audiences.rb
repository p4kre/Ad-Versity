class CreateCampaignAudiences < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_audiences do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :audience, null: false, foreign_key: true

      t.timestamps
    end
  end
end
