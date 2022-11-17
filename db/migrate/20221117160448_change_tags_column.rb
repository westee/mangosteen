class ChangeTagsColumn < ActiveRecord::Migration[7.0]
  def change
    remove_reference(:tags, :user, foreign_key: true)
    change_column_null(:tags, :name, false)
    change_column_null(:tags, :sign, false)
  end
end
