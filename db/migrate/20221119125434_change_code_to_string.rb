class ChangeCodeToString < ActiveRecord::Migration[7.0]
  def change
    change_column :validation_codes, :code, :string
  end
end
