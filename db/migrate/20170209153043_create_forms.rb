class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :hash_id
      t.string :name
      t.text :description
      t.string :url
      t.boolean :hidden, default: false
      t.datetime :created_on
      t.datetime :last_update

      t.timestamps null: false
    end

    change_table :questions do |t|
      t.references :form, foreign_key: true
      t.string :datatype
      t.string :field_id
      t.datetime :version_date
    end

    remove_column :submissions, :form_id, :string
    add_reference :submissions, :form, foreign_key: true
  end
end
