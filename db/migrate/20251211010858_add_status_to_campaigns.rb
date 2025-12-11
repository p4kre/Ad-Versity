class AddStatusToCampaigns < ActiveRecord::Migration[8.1]
  def change
    add_column :campaigns, :status, :string, default: "draft"
  end
end
