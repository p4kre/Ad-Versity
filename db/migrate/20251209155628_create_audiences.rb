class CreateAudiences < ActiveRecord::Migration[8.1]
  def change
    create_table :audiences do |t|
      t.string :name
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
