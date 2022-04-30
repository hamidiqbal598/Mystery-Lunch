class CreateMysteries < ActiveRecord::Migration[6.1]
  def change
    create_table :mysteries do |t|
      t.boolean :status, default: true, index: true
      t.string :month, index: true
      t.date :valid_till, index: true

      t.timestamps
    end
  end
end
