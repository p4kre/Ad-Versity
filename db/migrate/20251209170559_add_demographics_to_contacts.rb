class AddDemographicsToContacts < ActiveRecord::Migration[8.1]
  def change
    add_column :contacts, :age_range, :string
    add_column :contacts, :gender, :string
    add_column :contacts, :income_range, :string
    add_column :contacts, :education_level, :string
    add_column :contacts, :occupation, :string
    add_column :contacts, :marital_status, :string
    add_column :contacts, :family_status, :string
  end
end
