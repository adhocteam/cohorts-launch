class ChangeAnswerTextFromStringToText < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        change_column :answers, :value, :text
      end
      dir.down do
        change_column :answers, :value, :string
      end
    end
  end
end
