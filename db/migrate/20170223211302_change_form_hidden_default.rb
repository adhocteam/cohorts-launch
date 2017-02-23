class ChangeFormHiddenDefault < ActiveRecord::Migration
  def change
    change_column_default :forms, :hidden, false
  end
end
