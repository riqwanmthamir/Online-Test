class CreateTests < ActiveRecord::Migration
  def change
  	create_table :tests do |t|
  		t.string :test_name
  		t.integer :score
  		t.string :status
  	end
  end
end