class RxCreditCardFullDigitsBigint < ActiveRecord::Migration
  def change
    change_column :spree_credit_cards, :full_digits, :bigint
  end
end
