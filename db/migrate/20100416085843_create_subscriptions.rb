class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.decimal :amount, :precision => 10, :scale => 2
      t.timestamps
    end
  end
  
  def self.down
    drop_table :subscriptions
  end
end
