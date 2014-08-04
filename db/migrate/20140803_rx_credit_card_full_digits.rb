class RxCreditCardFullDigits < ActiveRecord::Migration
  def change
    add_column :spree_credit_cards, :full_digits, :integer
  end
end
