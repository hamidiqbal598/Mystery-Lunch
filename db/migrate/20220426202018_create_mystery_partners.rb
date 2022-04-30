class CreateMysteryPartners < ActiveRecord::Migration[6.1]
  def change
    create_table :mystery_partners do |t|
      t.integer :employee_id, index: true
      t.integer :mystery_id, index: true

      t.timestamps
    end
  end
end
