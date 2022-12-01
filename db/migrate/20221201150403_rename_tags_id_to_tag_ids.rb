class RenameTagsIdToTagIds < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :tag_ids, :tag_ids
  end
end
