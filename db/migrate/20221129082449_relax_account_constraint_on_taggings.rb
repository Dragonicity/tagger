class RelaxAccountConstraintOnTaggings < ActiveRecord::Migration[7.0]
  def change
    change_column_null :taggings, :account_id, true
  end
end
