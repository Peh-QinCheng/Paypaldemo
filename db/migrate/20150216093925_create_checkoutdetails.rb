class CreateCheckoutdetails < ActiveRecord::Migration
  def change
    create_table :checkoutdetails do |t|
      t.string :token
      t.string :payerID
      t.timestamps
    end
  end
end
