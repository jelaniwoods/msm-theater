class CreateLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :levels do |t|
      t.integer :number
      t.text :directions

      t.timestamps
    end
  end
end
