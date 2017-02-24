class ChangeFormFieldIdToArray < ActiveRecord::Migration
  def change
    add_column :questions, :choices, :string, array: true, default: []
    add_column :questions, :subfields, :string, array: true, default: []
    add_column :answers, :subfields, :string, array: true, default: []
  end
end
