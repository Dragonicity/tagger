class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      #t.belongs_to :account, null: false, foreign_key: true
      t.integer :taggings_count, default: 0

      t.timestamps
    end
  end
end
