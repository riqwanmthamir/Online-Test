class ManyTables < ActiveRecord::Migration
  def change
  	create_table :tests_questions, id: false do |t|
      t.integer :test_id
      t.integer :question_id
    end
  end
end
