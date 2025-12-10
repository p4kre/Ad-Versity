class CreateInsights < ActiveRecord::Migration[8.1]
  def change
    create_table :insights do |t|
      t.references :campaign, null: false, foreign_key: true
      t.integer :impressions
      t.integer :clicks
      t.decimal :spend
      t.integer :conversions

      t.timestamps
    end
  end
end
