class CreateLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_pages do |t|
      t.string :lede
      t.attachment :image
      t.belongs_to :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
