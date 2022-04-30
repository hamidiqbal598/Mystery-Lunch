class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :name, index: true
      t.string :department, index: true

      t.timestamps
    end
  end
end
