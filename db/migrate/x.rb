class AddCodeColumnForValidationCodes < ActiveRecord::Migration[7.0]
  def change
    add_column(:validation_codes, :code, :bigint)
  end
end
