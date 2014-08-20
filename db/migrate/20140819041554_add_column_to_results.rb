class AddColumnToResults < ActiveRecord::Migration
  def change
  	add_column :results, :test_id, :int
  end
end
