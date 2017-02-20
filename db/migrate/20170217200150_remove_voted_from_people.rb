class RemoveVotedFromPeople < ActiveRecord::Migration
  def change
    remove_column :people, :voted, :string
    remove_column :people, :contact_representative, :string
  end
end
