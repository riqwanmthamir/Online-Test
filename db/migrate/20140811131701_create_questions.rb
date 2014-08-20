class CreateQuestions < ActiveRecord::Migration
  def change
  	
  	create_table :questions do |t|
      t.string 	:question
      t.integer :test_id
      t.string	:achoice
      t.string	:bchoice
      t.string	:cchoice
      t.string 	:dchoice
      t.string	:answer
      t.integer	:result
    end
    
  end
end