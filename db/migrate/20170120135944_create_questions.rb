class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text
      t.string :short_text
      t.timestamps null: false
    end
  end
end
