class CreateTokenzs < ActiveRecord::Migration
  def change
    create_table :tokenzs do |t|
      t.string :tokenz
      t.string :payerID
      t.timestamps
    end
  end
end
