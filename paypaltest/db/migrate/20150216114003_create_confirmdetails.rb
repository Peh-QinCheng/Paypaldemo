class CreateConfirmdetails < ActiveRecord::Migration
  def change
    create_table :confirmdetails do |t|
      t.string :ordertotal
      t.string :itemtotal
      t.string :taxtotal
      t.string :shippingtotal
      t.timestamps
    end
  end
end
