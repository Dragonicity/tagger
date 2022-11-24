class CreateTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.belongs_to :tag, null: false, foreign_key: true
      t.references :taggable, polymorphic: true
      t.references :tagger, polymorphic: true
      t.string :context

      t.timestamps
    end
  end
end
