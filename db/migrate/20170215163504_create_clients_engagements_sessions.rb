class CreateClientsEngagementsSessions < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :engagements do |t|
      t.belongs_to :client, index: true, foreign_key: true
      t.string :topic, null: false
      t.date :start_date
      t.date :end_date
      t.text :notes
      t.text :search_query
      t.timestamps null: false
    end

    create_table :research_sessions do |t|
      t.belongs_to :engagement, index: true, foreign_key: true
      t.datetime :datetime, null: false
      t.text :notes
      t.timestamps null: false
    end

    create_join_table :research_sessions, :people, table_name: :session_invites do |t|
      t.index :research_session_id
      t.index :person_id
      t.boolean :attended
      t.timestamps null: false
    end
  end
end
