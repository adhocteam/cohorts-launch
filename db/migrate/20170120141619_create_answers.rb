class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :question, index: true, foreign_key: true
      t.belongs_to :person, index: true, foreign_key: true
      t.belongs_to :submission, index: true, foreign_key: true
      t.string :value
      t.timestamps null: false
    end
  end
end
