class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.string :token
      t.string :payerID
      t.timestamps
    end
  end
end
