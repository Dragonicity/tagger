class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.text :body
      t.string :tags
      t.string :reversed_meanings
      t.string :symbols

      t.timestamps
    end
  end
end
