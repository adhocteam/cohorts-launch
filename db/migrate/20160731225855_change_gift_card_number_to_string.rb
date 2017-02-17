class ChangeGiftCardNumberToString < ActiveRecord::Migration
  def change
    reversible do |dir|
  	   dir.up { change_column :gift_cards, :gift_card_number, :string }
       dir.down { change_column :gift_cards, :gift_card_number, :integer }
     end
  end
end
