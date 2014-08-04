class RxCvv < ActiveRecord::Migration
  def change
    add_column :spree_credit_cards, :cvv, :integer
  end
end
