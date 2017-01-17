class RemoveCalled311FromPeople < ActiveRecord::Migration
  def change
    remove_column :people, :called_311, :string
    remove_column :people, :neighborhood, :string
    add_column :people, :contact_representative, :string
  end
end
